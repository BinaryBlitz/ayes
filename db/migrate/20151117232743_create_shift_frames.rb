class CreateShiftFrames < ActiveRecord::Migration
  def change
    create_table :shift_frames do |t|
      t.integer :min_count
      t.float :delta

      t.timestamps null: false
    end
  end
end
