class DropSchedules < ActiveRecord::Migration
  def up
    drop_table :schedules
  end

  def down
    create_table :schedules do |t|
      t.belongs_to :question, index: true
      t.datetime :scheduled_for

      t.timestamps null: false
    end
  end
end
