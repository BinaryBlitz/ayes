class AddFieldsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :yes_ratio, :float
    add_column :answers, :total_count, :integer
    add_column :answers, :compared_at, :datetime, index: true
  end
end
