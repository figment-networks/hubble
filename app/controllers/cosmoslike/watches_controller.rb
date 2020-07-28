class Cosmoslike::WatchesController < Cosmoslike::BaseController

  def create
    thing = case params[:watchable_type]
            when 'account' then @chain.accounts.find_by( address: params[:watchable_finder].strip.downcase )
            when 'validator' then @chain.validators.find_by( owner: params[:watchable_finder].strip.downcase )
            else raise ActiveRecord::RecordNotFound
            end

    @chain.watches.create(
      watchable: thing,
      user: current_user
    )

    redirect_to namespaced_path( 'dashboard_path', @chain )
  end

end
