class SplitGaiadAndLcdHosts < ActiveRecord::Migration[5.2]
  def change
    %w{ cosmos iris terra kava }.each do |network|
      add_column :"#{network}_chains", :lcd_host, :string
      ActiveRecord::Base.connection.execute("UPDATE #{network}_chains SET lcd_host = gaiad_host")
    end
  end
end
