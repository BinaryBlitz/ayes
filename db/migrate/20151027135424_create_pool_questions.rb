class CreatePoolQuestions < ActiveRecord::Migration
  def change
    create_table :pool_questions do |t|
      t.integer :priority, default: 0
      t.belongs_to :question, index: true

      t.timestamps null: false
    end
  end
end
