class Livepeer::Pool < ApplicationRecord
  belongs_to :round

  has_many :shares, dependent: :delete_all
end
