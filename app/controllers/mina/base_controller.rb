class Mina::BaseController < Indexer::BaseController
  def page_title(value)
    super(@chain.network_name, @chain.name, value)
  end

  def meta_description(value)
    super("#{@chain.network_name} -- #{@chain.name} - #{value}")
  end
end
