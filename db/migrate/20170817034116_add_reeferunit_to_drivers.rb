class AddReeferunitToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :reeferunit, :boolean
  end
end
