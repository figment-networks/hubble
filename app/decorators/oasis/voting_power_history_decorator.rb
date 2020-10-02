class Oasis::VotingPowerHistoryDecorator
  include FormattingHelper

  def initialize(chain, validator)
    @validator = validator
    @chain = chain
  end

  def as_json
    q = @chain.client.validators_summary('day', '90 days', @validator.address)
    q = q.sort_by(&:time_bucket)

    data = q.map do |vph|
      {
        t: DateTime.parse(vph.time_bucket),

        y: vph.active_escrow_balance_avg.to_f
      }
    end

    data << { t: Time.now.utc.iso8601, y: @validator.recent_active_escrow_balance }

    first = data.first
    data.unshift(
      t: first[:t].utc.beginning_of_day.iso8601,
      y: first[:y]
    )

    data
  end
end
