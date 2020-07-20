require "indexer/resources/baker"

module Tezos
  class Search
    include ActiveModel::Model

    attr_accessor :query

    def results
      @results ||= Indexer::Baker.list(query: query)
    end
  end
end
