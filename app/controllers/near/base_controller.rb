class Near::BaseController < Indexer::BaseController
  layout 'redesign/application'

  private

  def page_title(value)
    super(@chain.network_name, @chain.name, value)
  end

  def meta_description(value)
    super("#{@chain.network_name} -- #{@chain.name} - #{value}")
  end

  def set_default_page_title
    page_title controller_name.titleize
  end

  def set_default_meta_description
    meta_description controller_name.titleize
  end
end
