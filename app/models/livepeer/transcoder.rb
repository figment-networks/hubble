class Livepeer::Transcoder < ApplicationRecord
  belongs_to :chain

  scope :active, -> { where(active: true) }
end
