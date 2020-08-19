class Indexer::BaseController < ApplicationController
  before_action :find_chain

  private

  def find_chain
    @chain ||= namespace::Chain.find_by!(slug: chain_slug)
  end

  def namespace
    @namespace ||= self.class.name.split('::').first.constantize
  end

  def chain_slug
    (params[:chain_id] || params[:id])
  end

  def client
    @client ||= namespace::Client.new(@chain.api_url)
  end
end
