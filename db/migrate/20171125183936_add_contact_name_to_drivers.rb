class AddContactNameToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :contact_name, :string
  end
end
