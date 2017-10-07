class FixDriversAddressAndStateFields < ActiveRecord::Migration
  def change
    rename_column :drivers, :address, :current_city
    rename_column :drivers, :state, :current_state
  end
end
