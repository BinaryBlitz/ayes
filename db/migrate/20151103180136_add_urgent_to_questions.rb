class AddUrgentToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :urgent, :boolean
  end
end
