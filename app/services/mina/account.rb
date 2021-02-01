module Mina
  class Account < Common::Resource
    field :public_key
    field :delegate
    field :balance, type: :integer
    field :balance_unknown, type: :integer
    field :start_time, type: :timestamp
    field :last_time, type: :timestamp
    field :start_height
    field :last_height

    def share_percent(total)
      if total > 0
        format '%d%%', ((balance * 100.0) / total).round(2)
      else
        '-'
      end
    end
  end
end
