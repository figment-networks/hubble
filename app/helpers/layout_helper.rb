module LayoutHelper
  def render_card(header, locals = {}, &blk)
    locals.merge!(
      header: header,
      card_class: locals[:class] || '',
      body_class: locals[:body_class] || ''
    )

    render('shared/card', locals, &blk)
  end
end
