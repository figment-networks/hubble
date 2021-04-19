module Near
  class PaginatedResponse
    attr_reader :page, :pages, :limit, :count, :records

    def initialize(resource_class, data)
      @page = data['page']
      @pages = data['pages']
      @count = data['count']
      @records = data['records'].map { |record| resource_class.new(record) }
    end
  end
end
