class DropPoolQuestions < ActiveRecord::Migration
  def up
    drop_table :pool_questions
  end

  def down
    create_table :pool_questions do |t|
      t.integer :priority, default: 0
      t.belongs_to :question, index: true

      t.timestamps null: false
    end
  end
end
