class MoreRpcAndLcdCleanup < ActiveRecord::Migration[5.2]
  def change
    %w{ cosmos iris terra kava }.each do |network|
      add_column :"#{network}_chains", :rpc_path, :string
      add_column :"#{network}_chains", :lcd_path, :string
      ActiveRecord::Base.connection.execute("UPDATE #{network}_chains SET lcd_path = '', rpc_path = ''")

      rename_column :"#{network}_chains", :gaiad_host, :rpc_host
      add_column :"#{network}_chains", :use_ssl_for_rpc, :boolean, default: false
    end
  end
end
