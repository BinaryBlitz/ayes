class AddRegionToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :region, :string, default: 'russia'
  end
end
