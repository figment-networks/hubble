class Polkadot::BlockDecorator < SimpleDelegator
  attr_reader :status

  def initialize(block, status)
    @status = status
    super(block)
  end

  def timestamp
    DateTime.parse(time)
  end

  def previous_block
    height - 1
  end

  def has_previous_block?
    height > 1
  end

  def next_block
    height + 1
  end

  def has_next_block?
    height != status.last_indexed_height
  end
end
