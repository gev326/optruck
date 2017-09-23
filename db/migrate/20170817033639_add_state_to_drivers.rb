class AddStateToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :state, :string
  end
end
