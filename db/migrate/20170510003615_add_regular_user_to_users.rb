class AddRegularUserToUsers < ActiveRecord::Migration
  def change
    add_column :users, :regular_user, :boolean, default: false

  end
end
