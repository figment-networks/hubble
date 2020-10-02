module Indexer
  class BakingStats
    attr_accessor :blocks_baked, :blocks_missed, :blocks_stolen

    def initialize(blocks_baked: 0, blocks_missed: 0, blocks_stolen: 0)
      @blocks_baked = blocks_baked
      @blocks_missed = blocks_missed
      @blocks_stolen = blocks_stolen
    end

    def total_rights
      blocks_baked - blocks_stolen + blocks_missed
    end

    def percent_baked
      return 1.0 if total_rights == 0

      blocks_baked / total_rights.to_f
    end

    def percent_missed
      return 0.0 if total_rights == 0

      blocks_missed / total_rights.to_f
    end
  end
end
