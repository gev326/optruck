class RemoveAdminAndUpdaterFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :admin, :bool
    remove_column :users, :updater, :bool
    remove_column :users, :regular_user, :bool
  end
end
