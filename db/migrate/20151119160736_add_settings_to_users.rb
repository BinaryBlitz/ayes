class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_question_notifications, :boolean, default: true
    add_column :users, :favorite_questions_notifications, :boolean, default: true
  end
end
