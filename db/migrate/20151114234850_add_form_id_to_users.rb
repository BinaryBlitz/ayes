class AddFormIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :form, index: true
  end
end
