class AddBackhaulToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :backhaul, :boolean
  end
end
