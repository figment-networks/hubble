module SkaleDelegationsHelper
  def lookup_delegation(delegation_summary)
    delegation_summary.each_with_object(Hash.new(0)) do |item, hash|
      hash[item.state] = item.amount
    end
  end
end
