class Hash
  def sort_by_key(recursive = false, &block)
    keys.sort(&block).each_with_object({}) do |key, seed|
      seed[key] = self[key]
      if recursive && seed[key].is_a?(Hash)
        seed[key] = seed[key].sort_by_key(true, &block)
      end
    end
  end
end
