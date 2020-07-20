class Cosmoslike::Transactions::TagDecorator
  include ActionView::Helpers::TagHelper
  include ActionView::Context
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper
  include NamespacedChainsHelper

  def initialize( json, chain )
    @key = json['key']
    @value = json['value']
    @chain = chain
  end

  def type
    formatted = case @key
                when 'action' then 'Action'
                when 'delegator' then 'Delegator'
                when 'destination-validator' then 'Validator'
                when 'source-validator' then 'Validator'
                when 'sender' then 'Sender'
                when 'recipient' then 'Recipient'
                else @key
                end

    tag.span(
      data: { toggle: 'tooltip', tooltip_side: 'right' },
      title: @key
    ) { formatted }
  end

  def value
    fn = :"handle_#{@key.underscore}"
    respond_to?(fn, true) ?
      send(fn, @value) :
      tag.span( class: 'technical' ) { @value }
  end

  private

  def handle_validator( value )
    bytes = Bitcoin::Bech32.decode( value )[1]
    account_address = Bitcoin::Bech32.encode( @chain.prefixes[:account_address].sub(/1$/, ''), bytes )
    handle_account( account_address )
  end
  alias :handle_destination_validator :handle_validator
  alias :handle_source_validator :handle_validator

  def handle_account( value )
    validator = @chain.accounts.find_by( address: value ).try(:validator)
    if validator
      link_to validator.short_name, namespaced_path( 'validator', validator )
    else
      tag.span( class: 'technical' ) do
        link_to value, namespaced_path( 'account', value )
      end
    end
  end
  alias :handle_delegator :handle_account
  alias :handle_sender :handle_account
  alias :handle_recipient :handle_account
end
