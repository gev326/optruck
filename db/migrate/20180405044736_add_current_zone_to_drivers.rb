class AddCurrentZoneToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :current_zone, :string
  end
end
