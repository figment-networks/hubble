class Cosmoslike::ValidatorSyncService
  def initialize(chain)
    @chain = chain
  end

  def update_history_height!
    @chain.update_attributes history_height: @chain.latest_local_height
  end

  def sync_validator_timestamps!
    from = [@chain.history_height + 1, @chain.blocks.last.height].max
    to = @chain.latest_local_height

    if to < from
      puts 'No unprocessed local blocks. Therefore no validator updates needed.'
    else
      existing_validators = @chain.validators.index_by(&:address)

      # snapshot current voting power on each validator
      ProgressReport.instance.start "Snapshotting quick info for #{@chain.network_name}/#{@chain.name} validators (blocks #{from} -> #{to})..."

      # figure out the last block each validator precommitted on
      latest_block_heights = existing_validators.values.each_with_object({}) do |v, h|
        h[v.address] = v.latest_block_height
      end
      latest_voting_powers = existing_validators.values.each_with_object({}) do |v, h|
        h[v.address] = v.current_voting_power
      end

      new_validators = 0
      (from..to).to_a.in_groups_of(500, false).each do |heights|
        chunk_start_time = Time.now.utc.to_f
        blocks = @chain.blocks.where(height: heights).reorder('height ASC').index_by(&:height)

        heights.each do |height|
          block = blocks[height] || @chain.namespace::Block.stub(@chain, height)

          # create any new validators we haven't seen before
          all_addresses = block.precommitters + block.validator_set.keys
          to_create = all_addresses.uniq - existing_validators.keys
          to_create.each do |new_addr|
            v = @chain.validators.create(
              address: new_addr,
              first_seen_at: block.timestamp
            )

            if v.persisted? && v.valid?
              new_validators += 1
              # puts "ADDED VALIDATOR: #{new_addr} #{v.valid?}"
              existing_validators[new_addr] = v
            elsif ENV['DEBUG']
              puts "Invalid validator found: #{new_addr.inspect}\nALL: #{all_addresses.inspect}\nTO CREATE: #{to_create.inspect}\n\n"
            end
          end

          existing_validators.values.each do |validator|
            relevant = block.precommitters.include?(validator.address) &&
                       (latest_block_heights[validator.address] || 0) < block.height
            latest_block_heights[validator.address] = block.height if relevant
            latest_voting_powers[validator.address] = block.validator_set[validator.address] || 0
          end
        end

        ProgressReport.instance.progress from, heights.last, to
        ProgressReport.instance.benchmark (Time.now.utc.to_f - chunk_start_time) / heights.count
      end

      print 'Saving updated validator info... '
      existing_validators.values.each do |validator|
        # puts "\t#{validator.address}\tVP: #{latest_voting_powers[validator.address]} LSB: #{latest_block_heights[validator.address]}"
        validator.assign_attributes(
          latest_block_height: latest_block_heights[validator.address] || 0,
          current_voting_power: latest_voting_powers[validator.address] || 0,
          current_uptime: validator.calculate_current_uptime,
          last_updated: Time.now
        )
        validator.save! if validator.changed?
      end
      puts 'DONE'

      ProgressReport.instance.report "Detected #{new_validators} new validators!"
    end
  end

  def sync_validator_metadata!
    syncer = @chain.syncer
    stake_info = syncer.get_stake_info

    if stake_info.nil? || !stake_info.is_a?(Array)
      puts 'No stake info, cannot sync metadata.'
      return
    end

    indexed_stake_info = stake_info.index_by { |info| info['consensus_pubkey'] }

    validators = @chain.validators
    total = validators.count

    ProgressReport.instance.start "Updating #{validators.count} #{@chain.network_name}/#{@chain.name} validators metadata..."

    validators.each_with_index do |validator, i|
      if validator.address.blank?
        raise "EXPLODE #{validator.inspect}"
      end

      # next if validator.latest_block_height.nil?
      validator_start_time = Time.now.utc.to_f

      begin
        height = validator.latest_block_height.zero? ? @chain.latest_local_height : validator.latest_block_height
        validator_set_result = syncer.get_validator_set(height)
        validator_in_set = validator_set_result.find { |v| v['address'] == validator.address }

        if validator_in_set.nil?
          extra_info = ENV['DEBUG'] ? " -- (set: #{validator_set_result.map { |vi| vi['address'] }.inspect})" : ''
          raise "Validator #{validator.address} (id: #{validator.id}) not found in set for height #{height}#{extra_info}"
        end

        amino_pub_key = validator_in_set['pub_key']['value']
        bech32_key = @chain.namespace::KeyConverter.pubkey_to_bech32(amino_pub_key, @chain.prefixes[:validator_consensus_public_key])

        if indexed_stake_info[bech32_key]
          validator.update_attributes info: indexed_stake_info[bech32_key]
        end
      rescue StandardError
        puts "Could not get validator info for #{validator.address} -- #{$!.message}\n\n"
      end

      # is there an account with a matching address we should link to?
      begin
        account_address = Bitcoin::Bech32.encode(
          @chain.prefixes[:account_address].sub(/1$/, ''),
          Bitcoin::Bech32.decode(validator.info['operator_address'])[1]
        )
      rescue StandardError
        puts "No account/validator link found for: #{validator.address}" if ENV['DEBUG']
        account_address = nil
      end

      if account_address
        account = @chain.accounts.find_or_create_by!(address: account_address)
        account&.update_attributes(validator: validator)
      end

      ProgressReport.instance.progress 0, i + 1, total
      ProgressReport.instance.benchmark Time.now.utc.to_f - validator_start_time
    end

    ProgressReport.instance.report
  end
end
