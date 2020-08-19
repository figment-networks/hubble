class RemoveTranscoderFromLivepeerDelegators < ActiveRecord::Migration[5.2]
  def change
    remove_reference :livepeer_delegators, :transcoder
  end
end
