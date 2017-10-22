class AddDestinationZoneToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :destination_zone, :string
  end
end
