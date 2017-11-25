class AddPlateTrailerToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :PlateTrailer, :boolean
  end
end
