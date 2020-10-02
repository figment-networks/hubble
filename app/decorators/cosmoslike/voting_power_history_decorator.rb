class Cosmoslike::VotingPowerHistoryDecorator
  include FormattingHelper

  def initialize(validator)
    @validator = validator
  end

  def as_json
    return [] if @validator.voting_power_history.empty?

    data = @validator.voting_power_history.reverse.map do |vph|
      {
        t: vph.timestamp.iso8601,
        h: vph.height,
        y: vph.data['to'].to_f
      }
    end

    data << { t: Time.now.utc.iso8601, y: @validator.current_voting_power }

    first = data.first
    data.unshift(
      t: (@validator.chain.cutoff_at || Time.parse(first[:t]).utc.beginning_of_day).iso8601,
      y: @validator.chain.cutoff_at ? first[:y] : 0
    )

    data
  end
end
