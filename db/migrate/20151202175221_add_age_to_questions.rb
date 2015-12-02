class AddAgeToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :age, :integer, array: true, default: []
  end
end
