class Cosmoslike::ValidatorEventsService
  EVENT_ORDER = %w[
    active_set_inclusion
    voting_power_change
    n_of_m
    n_consecutive
  ].freeze

  def initialize(chain)
    @chain = chain
  end

  def run!
    definitions = @chain.validator_event_defs.group_by { |defn| defn['kind'] }

    EVENT_ORDER.each do |kind|
      next unless definitions[kind] # chain has no definitions of this kind

      definitions[kind].each do |defn|
        if defn_is_valid? defn
          puts "Running event (chain: #{@chain.name}) definition: #{defn['kind']} #{defn['unique_id']}..."
          public_send(:"run_#{defn['kind']}!", *defn_params(defn))
        end
      end
    end
  end

  def run_n_consecutive!(defn_id, n)
    from = @chain.get_event_height(defn_id) + 1
    to = @chain.latest_local_height

    if to < from
      puts 'No new local blocks to generate n-consecutive threshold events.'
    else
      existing_validators = @chain.validators.index_by(&:address)
      latches = existing_validators.values.each_with_object({}) do |v, h|
        h[v.address] = Common::ValidatorEventLatch.find_or_create_by!(
          chainlike: @chain,
          validatorlike: v,
          event_definition_id: defn_id
        )
      end

      ProgressReport.instance.start "Updating n-consecutive (#{n} consecutive) threshold events (block #{from} -> #{to})..."

      insert_events(from, to) do |block|
        existing_validators.values.each do |validator|
          address = validator.address
          latch = latches[address]

          if latch.state.nil?
            latch.state = 0
          end

          if !validator.in_active_set?(block)
            new_state = 0
            tripped = false
          else
            # update the latch according to the event definition
            voted = block.precommitters.include?(address)
            new_state = voted ? 0 : (latch.state.to_i + 1)
            tripped = new_state >= n
          end

          if tripped
            if !latch.held?
              begin
                Common::ValidatorEvents::NConsecutive.create!(
                  chainlike: @chain,
                  validatorlike: validator,
                  height: block.height,
                  timestamp: block.timestamp,
                  event_definition_id: defn_id,
                  data: { n: n }
                )
              rescue StandardError
                raise @chain.namespace::SyncBase::CriticalError, "Could not create n-consecutive validator event. #{validator.address} #{n} at height #{block.height}"
              end

              # make sure to hold the latch
              latch.assign_attributes held: true
            end
          else
            # make sure we dont hold the latch anymore, if we do
            latch.assign_attributes held: false
          end

          latch.assign_attributes state: new_state.to_s
          latch.save! if latch.changed?
        end

        @chain.set_event_height! defn_id, block.height
      end

      ProgressReport.instance.report
    end
  end

  def run_n_of_m!(defn_id, n, m)
    from = @chain.get_event_height(defn_id) + 1
    to = @chain.latest_local_height

    if to < from
      puts 'No new local blocks to generate n-of-m threshold events.'
    else
      existing_validators = @chain.validators.index_by(&:address)
      latches = existing_validators.values.each_with_object({}) do |v, h|
        h[v.address] = Common::ValidatorEventLatch.find_or_create_by!(
          chainlike: @chain,
          validatorlike: v,
          event_definition_id: defn_id
        )
      end

      ProgressReport.instance.start "Updating n-of-m (#{n}-of-#{m}) threshold events (block #{from} -> #{to})..."

      insert_events(from, to) do |block|
        existing_validators.values.each do |validator|
          address = validator.address
          latch = latches[address]

          if latch.state.nil?
            latch.state = '0' * m
          end

          if !validator.in_active_set?(block)
            new_state = '0' * m
            tripped = false
          else
            # update the latch according to the event definition
            voted = block.precommitters.include?(address)
            new_state = latch.state[1..-1] << (voted ? '0' : '1')
            tripped = new_state.count('1') >= n
          end

          if tripped
            if !latch.held?
              begin
                Common::ValidatorEvents::NOfM.create!(
                  chainlike: @chain,
                  validatorlike: validator,
                  height: block.height,
                  timestamp: block.timestamp,
                  event_definition_id: defn_id,
                  data: { n: n, m: m }
                )
              rescue StandardError
                raise @chain.namespace::SyncBase::CriticalError, "Could not create n-of-m validator event. #{validator.address} #{n} of #{m} at height #{block.height}"
              end

              # make sure to hold the latch
              latch.assign_attributes held: true
            end
          else
            # make sure we dont hold the latch anymore, if we do
            latch.assign_attributes held: false
          end

          latch.assign_attributes state: new_state
          latch.save! if latch.changed?
        end

        @chain.set_event_height! defn_id, block.height
      end

      ProgressReport.instance.report
    end
  end

  def run_voting_power_change!(defn_id)
    from = @chain.get_event_height(defn_id) + 1
    to = @chain.latest_local_height

    if to < from
      puts 'No new local blocks to generate voting power change events.'
    else
      existing_validators = @chain.validators.index_by(&:address)

      latest_voting_power_changes = existing_validators.values.each_with_object({}) do |v, h|
        h[v.address] = v.events.voting_power_change.first.try(:to).to_i
      end

      ProgressReport.instance.start "Updating voting power change history (block #{from} -> #{to})..."

      get_active_set_changes = lambda do |blocks|
        Common::ValidatorEvents::ActiveSetInclusion.
          where(chainlike: @chain, height: blocks.map(&:height)).
          group_by(&:height)
      end

      insert_events(from, to, get_active_set_changes) do |block, active_set_changes|
        active_set_changes = (active_set_changes || []).index_by(&:validatorlike_id)

        block.validator_set.each do |address, voting_power|
          # sanity check to make sure we have this validator
          if !existing_validators.keys.include?(address)
            raise @chain.namespace::SyncBase::CriticalError, "Unknown validator #{address} in validator set for block #{block.height}."
          end

          # sanity check to make sure there is a valid voting power number
          if voting_power.nil?
            raise @chain.namespace::SyncBase::CriticalError, "Invalid voting power for #{address}: #{voting_power.inspect}"
          end

          validator = existing_validators[address]

          # find a potential active set change for this block
          active_set_change = active_set_changes[validator.id]

          # if voting power changed from last time we saw it,
          # record an update. but *skip this* if this change was
          # part of being removed from the active set
          # puts "\n\n#{address} / #{height}\tis active set change #{!active_set_change.nil?}\n#{existing_validators[address].first_seen_at}/#{block.timestamp} -> #{existing_validators[address].first_seen_at == block.timestamp}\npositive? #{active_set_change.try(:positive?) || false}\nvoting power changed? #{latest_voting_powers[address] != voting_power}\nSHOULD RECORD? #{should_record}"
          next unless latest_voting_power_changes[address] != voting_power

          next unless !active_set_change || active_set_change.added?

          # only actually create an event if the change is over a threshold
          # or takes the validator up from zero
          significant = Common::ValidatorEvents::VotingPowerChange.significant_change?(
            latest_voting_power_changes[address],
            voting_power
          )

          if latest_voting_power_changes[address].zero? || significant
            begin
              Common::ValidatorEvents::VotingPowerChange.create!(
                chainlike: @chain,
                validatorlike: validator,
                height: block.height,
                timestamp: block.timestamp,
                event_definition_id: defn_id,
                data: {
                  from: latest_voting_power_changes[address],
                  to: voting_power
                }
              )
              # puts "\t\tADDED VOTING POWER CHANGE: #{validator.moniker} #{latest_voting_power_changes[address]} -> #{voting_power}"
              # puts "######################################################################################################################################################################################################################################################################################################################"
              # sleep 5
            rescue StandardError
              raise @chain.namespace::SyncBase::CriticalError, "Could not create voting-power-change validator event. #{validator.address} #{voting_power} at height #{block.height}"
            end
          end

          latest_voting_power_changes[address] = voting_power || 0
        end

        @chain.set_event_height! defn_id, block.height
      end

      ProgressReport.instance.report
    end
  end

  def run_active_set_inclusion!(defn_id)
    from = @chain.get_event_height(defn_id) + 1
    to = @chain.latest_local_height

    if to < from
      puts 'No new local blocks to generate active set inclusion events.'
    else
      ProgressReport.instance.start "Generating validator in/out of active set events (block #{from} -> #{to})..."

      validators = @chain.validators.index_by(&:address)

      prev_block = @chain.blocks.find_by(height: from - 1)
      insert_events(from, to) do |block|
        first_block = true if prev_block.nil?

        validators.keys.each do |address|
          next if validators[address].first_seen_at.nil? || block.timestamp < validators[address].first_seen_at

          in_set = block.validator_set.keys.include?(address)
          in_prev_set = first_block ? false : prev_block.validator_set.keys.include?(address)

          removed = in_prev_set && !in_set
          added = !in_prev_set && in_set

          begin
            if removed
              # puts "VALIDATOR #{address} left active set (#{block.height})"
              Common::ValidatorEvents::ActiveSetInclusion.create!(
                chainlike: @chain,
                validatorlike: validators[address],
                height: block.height,
                timestamp: block.timestamp,
                event_definition_id: defn_id,
                data: { status: 'removed' }
              )
            elsif added
              # puts "VALIDATOR #{address} joined active set (#{block.height})"
              Common::ValidatorEvents::ActiveSetInclusion.create!(
                chainlike: @chain,
                validatorlike: validators[address],
                height: block.height,
                timestamp: block.timestamp,
                event_definition_id: defn_id,
                data: { status: 'added' }
              )
            end
          rescue StandardError
            puts $!.message
            puts $!.backtrace.join("\n")
            raise @chain.namespace::SyncBase::CriticalError, "Could not create active-set-inclusion validator event. #{address} #{if added
                                                                                                                                    'added'
                                                                                                                                  else
                                                                                                                                    removed ? 'removed' : 'no change...?'
                                                                                                                                  end} at height #{block.height}"
          end
        end

        @chain.set_event_height! defn_id, block.height
        prev_block = block
      end

      ProgressReport.instance.report
    end
  end

  private

  def insert_events(from, to, extra_arg_proc = nil, debug: false, &process)
    (from..to).to_a.in_groups_of(500, false).each do |heights|
      puts "HEIGHTS TO GET: #{heights.inspect}" if debug
      found_blocks = @chain.blocks.where(height: heights).reorder('height ASC').index_by { |b| b.height.to_i }

      blocks = heights.map(&:to_i).sort.map do |height|
        found_blocks[height] || @chain.namespace::Block.stub(@chain, height)
      end

      extra_arg = extra_arg_proc ? extra_arg_proc.call(blocks) : nil

      blocks.each do |block|
        puts "\tBLOCK #{block.height}" if debug
        block_start_time = Time.now.utc.to_f

        args = [block, extra_arg ? extra_arg[block.height] : nil].compact
        process.call(*args)

        ProgressReport.instance.progress from, block.height, to
        ProgressReport.instance.benchmark Time.now.utc.to_f - block_start_time
      end
    end
  end

  def defn_params(defn)
    case defn['kind']
    when 'voting_power_change' then [defn['unique_id']]
    when 'active_set_inclusion' then [defn['unique_id']]
    when 'n_of_m' then [defn['unique_id'], defn['n'], defn['m']]
    when 'n_consecutive' then [defn['unique_id'], defn['n']]
    end
  end

  def defn_is_valid?(defn)
    case defn['kind']
    when 'voting_power_change' then true
    when 'active_set_inclusion' then true
    when 'n_of_m'
      defn['n'].is_a?(Numeric) &&
        defn['m'].is_a?(Numeric) &&
        defn['n'] < defn['m']
    when 'n_consecutive'
      defn['n'].is_a?(Numeric)
    else
      false
    end
  end
end
