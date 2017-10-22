class AddLangToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :lang, :string
  end
end
