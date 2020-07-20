module FlashHelper
  def render_flash_messages
    return if flash.empty?

    items = []

    flash.each do |key, value|
      key = "danger" if key == "error"
      items << content_tag(:div, class: "alert alert-#{key}") do
        content_tag(:div, class: "container text-center") { value }
      end
    end

    flash.discard
    items.join.html_safe
  end
end
