class AddPreferredLanesToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :PreferredLanes, :string
  end
end
