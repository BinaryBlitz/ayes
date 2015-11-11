class AddPublishedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :published_at, :datetime
    add_column :questions, :position, :integer
  end
end
