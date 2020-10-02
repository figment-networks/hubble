module NamespacedChainsHelper
  def namespaced_path(path = nil, *args, chain: @chain, pre_path: false, full: false, admin: false, **kwargs)
    if chain.nil?
      raise ArgumentError, 'Cannot generate path without a chain.'
    end

    path_method = [
      if pre_path
        pre_path.is_a?(String) ? pre_path : path
      end,
      admin ? 'admin' : nil,
      chain.class.name.deconstantize.downcase,
      'chain',
      if pre_path
        pre_path.is_a?(String) && path.is_a?(String) ? path : nil
      else
        path
      end,
      full ? 'url' : 'path'
    ].compact.join('_')

    # chain at the front of all argument lists
    args.unshift(chain)

    # Rails.logger.debug "NAMESPACED: #{path_method} #{args}"

    public_send(path_method, *args, kwargs)
  end
end
