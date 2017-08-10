class AddCoveredToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :Covered, :boolean
  end
end
