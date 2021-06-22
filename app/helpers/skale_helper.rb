module SkaleHelper
  def skale_chain_dashboard_path(*_args)
    skale_root_path
  end

  def node_visible?(status)
    visible = %w[Active In_Maintenance]
    visible.include?(status)
  end
end
