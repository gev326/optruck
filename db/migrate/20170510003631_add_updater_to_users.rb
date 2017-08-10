class AddUpdaterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :updater, :boolean, default: false
  end
end
