class Cosmoslike::Transactions::MessageDecorator
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include FormattingHelper
  include NamespacedChainsHelper

  def initialize(json, chain)
    @object = json
    @chain = chain
  end

  def type(tooltip: true)
    if tooltip
      tag.span(
        data: { toggle: 'tooltip', tooltip_side: 'right' },
        title: @object['type']
      ) { humanized_type }
    else
      humanized_type
    end
  end

  def each_info
    @object['value'].each do |k, v|
      fn = :"handle_#{k}"
      value = respond_to?(fn, true) ? send(fn, v) : v
      yield k, nice_info_key(k), value
    end
  end

  private

  def humanized_type
    sanitized = @object['type'].sub(/^cosmos-sdk\//, '')
    case sanitized
    when 'MsgWithdrawValidatorRewardsAll' then 'Withdraw All Rewards'
    when 'MsgWithdrawDelegationReward' then 'Withdraw Rewards'
    when 'MsgBeginRedelegate' then 'Redelegation'
    when 'MsgUndelegate' then 'Undelegate'
    when 'MsgWithdrawValidatorCommission' then 'Withdraw Commission'
    when 'MsgDelegate' then 'Delegation'
    when 'MsgDeposit' then 'Deposit'
    when 'MsgSend' then 'Send'
    when 'MsgUnjail' then 'Unjail'
    else sanitized
    end
  end

  def nice_info_key(key)
    case key
    when 'validator_address', 'validator_addr' then 'Validator'
    when 'delegator_address', 'delegator_addr' then 'Delegator'
    when 'depositor' then 'Depositor'
    when 'proposal_id' then 'Proposal'
    when 'delegation' then 'Delegation'
    when 'inputs' then 'Inputs'
    when 'outputs' then 'Outputs'
    when 'address' then 'Address'
    when 'coins' then 'Coins'
    when 'value' then 'Value'
    when 'to_address' then 'To'
    when 'from_address' then 'From'
    when 'amount' then 'Amount'
    else key
    end
  end

  def handle_amount(value_or_values)
    values = value_or_values.is_a?(Array) ? value_or_values : [value_or_values]
    values.map do |coin|
      format_amount(coin['amount'].to_i, @chain, denom: coin['denom'])
    end.join.html_safe
  end
  alias handle_delegation handle_amount
  alias handle_value handle_amount

  def handle_validator(value)
    bytes = Bitcoin::Bech32.decode(value)[1]
    account_address = Bitcoin::Bech32.encode(
      @chain.class::PREFIXES[:account_address].sub(/1$/, ''), bytes
    )
    handle_account(account_address)
  end
  alias handle_validator_address handle_validator

  def handle_account(value)
    validator = @chain.accounts.find_by(address: value).try(:validator)
    if validator
      link_to validator.short_name, namespaced_path('validator', validator)
    else
      tag.span(class: 'technical') do
        link_to value, namespaced_path('account', value)
      end
    end
  end
  alias handle_depositor handle_account
  alias handle_delegator_address handle_account
  alias handle_address handle_account
  alias handle_to_address handle_account
  alias handle_from_address handle_account

  def handle_proposal_id(value)
    p = @chain.governance_proposals.find_by(ext_id: value)
    return 'Unknown' unless p

    link_to p.title.truncate(30), namespaced_path('governance_proposal', p)
  end

  def handle_send(value)
    return value.map do |input|
      tag.div(class: 'mb-1') do
        tag.div(class: 'mb-1 d-flex align-items-center') do
          handle_account(input['address'])
        end +
        tag.span(class: 'fa fa-arrow-right text-sm mr-2 text-info') +
        handle_amount(input['coins'])
      end
    end.join.html_safe
  end
  alias handle_inputs handle_send
  alias handle_outputs handle_send
end
