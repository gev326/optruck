class AddInsuranceToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :insurance, :string
  end
end
