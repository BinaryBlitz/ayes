class CreateMergeGroups < ActiveRecord::Migration
  def change
    create_table :merge_groups do |t|
      t.string :field
      t.string :options, array: true, default: []

      t.timestamps null: false
    end
  end
end
