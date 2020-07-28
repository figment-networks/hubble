class Cosmoslike::BlockSyncService
  BATCH_SIZE = 20

  def initialize( chain )
    @chain = chain
  end

  def sync!
    syncer = @chain.syncer( 10_000 )
    sync_start_height = @chain.latest_local_height
    target_height = syncer.get_head_height
    target_height -= @chain.class::SYNC_OFFSET # leave some blocks off (non-canonical, or stay behind on purpose)

    latest_local = sync_start_height

    if ENV['LIMIT_NEW_BLOCKS']
      target_height = [sync_start_height + ENV['LIMIT_NEW_BLOCKS'].to_i, target_height].min
    end

    if sync_start_height >= target_height
      puts "No new blocks to sync."
    else
      ProgressReport.instance.start "Syncing #{target_height - sync_start_height} blocks on #{@chain.slug} (#{sync_start_height+1} -> #{target_height}) from #{@host}..."

      while latest_local < target_height
        batch_start_time = Time.now.utc.to_f

        page_start = latest_local+1
        page_end = [latest_local+BATCH_SIZE, target_height].min
        break if page_start > page_end

        data = syncer.get_blocks( page_start, page_end )
        break if data.has_key?('error')

        heights = data['result']['block_metas'].map { |bm| bm.dig('header', 'height').to_i }.sort
        expected_heights = (page_start..page_end).to_a.sort
        if heights != expected_heights
          puts "\n\nDEBUG PAYLOAD: #{data.to_json}\n\n\n"
          raise @chain.namespace::SyncBase::CriticalError.new("Block page #{page_start} -> #{page_end} is missing heights!\nExpected: #{expected_heights.join(', ')}\nFound: #{heights.join(', ')}\nMissing: #{(expected_heights - heights).join(', ')}\n\n")
        end

        blocks_data = data['result']['block_metas']

        # ensure we don't have any bad data
        blocks_data.each do |block|
          if block.dig('header', 'height').nil?
            raise @chain.namespace::SyncBase::CriticalError.new("Empty block object found in page #{page_start}->#{page_end}")
          end
        end

        # drop any old blocks we've already seen
        blocks_data.select! do |block|
          block.dig('header', 'height').to_i > latest_local
        end

        # ensure blocks sorted by height
        blocks_data.sort_by! do |block|
          block.dig('header', 'height').to_i
        end

        blocks_data.each do |block|
          height = block['header']['height'].to_i

          begin
            commit = syncer.get_commit(height)

            if !commit['result']['canonical']
              target_height = height - 1
              break
            end
          rescue
            puts "\n\nDEBUG PAYLOAD: #{commit.to_json}\n\n\n"
            raise @chain.namespace::SyncBase::CriticalError.new("Empty or invalid commit object found for block #{height}.")
          end

          obj = @chain.namespace::Block.assemble(
            @chain, height,
            block, commit, syncer.get_validator_set(height)
          )

          # if obj[:transactions].try(:any?)
          #   begin
          #     txs = obj[:transactions].map { |hash| syncer.get_transaction(hash) }
          #     raise RuntimeError.new("Could not get all transactions.") if txs.any?(&:nil?)
          #     @chain.namespace::AccountFinder.new( @chain, txs, :transactions ).run
          #   rescue
          #     puts "Failed to run account finder for block #{height}: #{$!.message}"
          #     puts $!.backtrace.join("\n") if Rails.env.development?
          #   end
          # end

          created = @chain.blocks.create( obj )

          if !created.valid? || !created.valid?
            raise @chain.namespace::SyncBase::CriticalError.new("Failed to create block at height #{height}.")
          end

          latest_local = height
          @chain.update_attributes latest_local_height: latest_local

          ProgressReport.instance.progress sync_start_height, height, target_height
        end

        ProgressReport.instance.benchmark (Time.now.utc.to_f - batch_start_time) / blocks_data.count
      end

      ProgressReport.instance.report
    end

    @chain.update_attributes last_sync_time: Time.now.utc
  end

  def cleanup!
    clean_older_than = @chain.latest_local_height - 1000

    to_clean = @chain.blocks.where( 'height <= ?', clean_older_than )
    count = to_clean.count

    if count == 0
      puts "No blocks to clean."
    else
      ProgressReport.instance.start "Cleaning unneeded blocks on #{@chain.slug} (#{count} older than #{clean_older_than})..."

      i = 0
      to_clean.find_each do |block|
        i += 1
        block.destroy
        ProgressReport.instance.progress 0, i, count
        ProgressReport.instance.benchmark i / count.to_f
      end

      ProgressReport.instance.report
    end
  end
end
