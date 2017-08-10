class AddPlateTrailerToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :PlateTrailer, :string
  end
end
