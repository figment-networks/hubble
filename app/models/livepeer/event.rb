class Livepeer::Event < ApplicationRecord
  belongs_to :round

  def kind_string
    self.class.name.demodulize.underscore
  end

  def to_partial_path
    self.class.name.underscore
  end

  def positive?
    raise NotImplementedError
  end

  def icon_name
    raise NotImplementedError
  end

  def transcoder
    round.chain.transcoders.find_by(address: transcoder_address)
  end
end

require_dependency 'livepeer/events/reward_cut_change'
