module NearHelper
  def near_chain_dashboard_path(*_args)
    near_root_path
  end

  def near_epoch_efficiency_color(efficiency)
    case efficiency
    when 0..90
      'text-danger'
    when 90..97
      'text-warning'
    else
      ''
    end
  end
end
