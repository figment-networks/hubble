module EventsHelper
  def get_icon_class(event)
    return "fa fa-#{event.icon_name} text-#{event.positive? ? 'success' : 'danger'}"
  end
end
