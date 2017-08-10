class AddEtracToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :Etrac, :string
  end
end
