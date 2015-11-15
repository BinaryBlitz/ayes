class RemoveCityFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :city, :string
    remove_column :forms, :city, :string
  end
end
