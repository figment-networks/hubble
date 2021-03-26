module TokenMap
  extend ActiveSupport::Concern

  def token_display
    self.class::DEFAULT_TOKEN_DISPLAY
  end

  def primary_token
    self.class::DEFAULT_TOKEN_REMOTE
  end

  def token_map
    self.class.token_map[slug] || self.class.token_map['default']
  end

  class_methods do
    def token_map
      {
        'default' => {
          self::DEFAULT_TOKEN_REMOTE => {
            'factor' => self::DEFAULT_TOKEN_FACTOR,
            'display' => self::DEFAULT_TOKEN_DISPLAY,
            'primary' => true
          }
        }
      }
    end
  end
end
