class AddFieldsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :gender, :string, array: true
    add_column :questions, :occupation, :string, array: true
    add_column :questions, :income, :string, array: true
    add_column :questions, :education, :string, array: true
    add_column :questions, :relationship, :string, array: true
    add_column :questions, :settlement, :string, array: true
  end
end
