class ChangeQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :urgent, :boolean, default: false
  end
end
