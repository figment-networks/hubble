class Common::AccountFinder

  def initialize( chain, transaction, type )
    @type = type
    @chain = chain
    @transaction = transaction
  end

  def run
    case @type
    when :transactions then find_in_transactions
    else raise ArgumentError.new( "AccountFinder does not support #{@type}." )
    end
  end

  private

  def find_in_transactions
    @transaction.message.map { |msg| msg['value'] }.flatten.map do |info|
      info.entries.map do |k, v|
        case k
        when 'validator_addr' then validator_operator_address_to_account_address(v)
        when 'delegator_addr' then v
        when 'validator_address' then validator_operator_address_to_account_address(v)
        when 'delegator_address' then v
        when 'depositor' then v
        else
          # we don't know all the keys right now
          # so let's do a ham-fisted string check
          # to see if this is likely an account address
          if v.is_a?(String) && v.starts_with?( @chain.prefixes[:account_address] ) then v
          elsif v.is_a?(String) && v.starts_with?( @chain.prefixes[:validator_operator_address] ) then validator_operator_address_to_account_address(v)
          else nil
          end
        end
      end
    end.flatten.compact.each do |address|
      account = @chain.accounts.find_or_create_by!( address: address )
      account.txs << @transaction unless account.txs.include? @transaction
    end
  end

  def validator_operator_address_to_account_address( v )
    bytes = Bitcoin::Bech32.decode( v )[1]
    Bitcoin::Bech32.encode( @chain.prefixes[:account_address].sub(/1$/, ''), bytes )
  end
end
