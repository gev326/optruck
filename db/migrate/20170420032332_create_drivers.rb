class CreateDrivers < ActiveRecord::Migration
  def change
    create_table :drivers do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :desired_city
      t.string :desired_state
      t.string :desired_zip
      t.string :driver_id_tag
      t.string :driver_phone
      t.string :driver_truck_type
      t.string :active
      t.string :driver_status
      t.string :driver_contract_number
      t.date :driver_availability
      t.string :driver_company
      t.string :comments
      t.boolean :active

      t.timestamps null: false
    end
  end
end
