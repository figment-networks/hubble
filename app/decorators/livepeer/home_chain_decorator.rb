class Livepeer::HomeChainDecorator < HomeChainDecorator
  def transcoders?
    transcoder_count.present? && transcoder_count > 0
  end

  def transcoder_count
    transcoders.count unless transcoders.nil?
  end
end
