class AddUserIdToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :user_id, :integer
    add_index :drivers, :user_id
  end
end
