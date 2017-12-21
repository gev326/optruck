class AddEtracToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :Etrac, :boolean
  end
end
