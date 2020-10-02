class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def has_dashboard?
    false
  end
end
