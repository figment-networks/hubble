module Indexer
  class EndorsingStats
    attr_accessor :total_slots, :endorsed_slots

    def initialize(total_slots: 0, endorsed_slots: 0)
      @total_slots = total_slots
      @endorsed_slots = endorsed_slots
    end

    def missed_slots
      total_slots - endorsed_slots
    end

    def percent_endorsed
      return 1.0 if total_slots == 0

      endorsed_slots / total_slots.to_f
    end

    def percent_missed
      1 - percent_endorsed
    end
  end
end
