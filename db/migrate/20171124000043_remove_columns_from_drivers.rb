class RemoveColumnsFromDrivers < ActiveRecord::Migration[5.0]
  def change
    remove_column :drivers, :driver_contract_number
    remove_column :drivers, :lang
    remove_column :drivers, :reeferunit
  end
end
