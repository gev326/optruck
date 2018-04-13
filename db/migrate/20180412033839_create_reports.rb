class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :driver_ids, array: true, default: []
      t.string :full_name_cont
      t.string :driver_id_tag_eq
      t.string :current_state_eq
      t.string :current_city_cont
      t.integer :miles
      t.string :driver_company_cont
      t.string :driver_phone_cont
      t.string :driver_truck_type_eq
      t.boolean :active_eq
      t.boolean :PlateTrailer_eq
      t.boolean :Etrac_eq
      t.boolean :backhaul_eq
      t.string :driver_availability_in
      t.string :PreferredLanes_cont_any
      t.string :destination_zone_cont_any
      t.string :current_zone_cont_any

      t.timestamps
    end
  end
end
