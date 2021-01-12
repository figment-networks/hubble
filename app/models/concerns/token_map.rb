module TokenMap
  extend ActiveSupport::Concern

  def token_display
    self.class::DEFAULT_TOKEN_DISPLAY
  end

  def token_map
    self.class.token_map[slug] || self.class.token_map['default']
  end
end
