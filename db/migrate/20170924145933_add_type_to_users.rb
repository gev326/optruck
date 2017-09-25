class AddTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_type, :string, default: 'dispatcher', null: false
  end
end
