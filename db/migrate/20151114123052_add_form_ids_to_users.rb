class AddFormIdsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :form_ids, :integer, array: true, default: []
  end
end
