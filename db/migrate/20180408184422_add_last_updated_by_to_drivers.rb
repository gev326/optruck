class AddLastUpdatedByToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :last_updated_by, :string
  end
end
