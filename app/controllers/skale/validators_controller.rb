class Skale::ValidatorsController < Skale::BaseController
  def show
    if params[:accounts_page].present?
      @validator = client.validators(address: params[:id]).first
      params[:id] = @validator.id
    else
      @validator = client.validator(params[:id])
    end
    raise ActiveRecord::RecordNotFound unless @validator

    staked_from = 6.months

    @nodes = client.nodes(validator_id: @validator.id)
    @staked_stats = total_staked(staked_from)
    @delegation_summary = client.delegation_summary(validator_id: @validator.id, time_at: Time.now.iso8601)

    page_title 'Validator'
    meta_description "Validator #{@validator.name}"
  end

  private

  def total_staked(staked_from)
    client.staked_over_time(id: @validator.id, from: staked_from.ago.iso8601, to: Time.now.iso8601, timeline: 'true', type: 'TOTAL_STAKE').reverse.map do |validator_summary|
      Skale::StakedChartDecorator.new(validator_summary).point(@chain)
    end
  end
end
