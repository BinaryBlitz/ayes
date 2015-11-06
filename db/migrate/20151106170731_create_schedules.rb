class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.belongs_to :question, index: true
      t.datetime :scheduled_for

      t.timestamps null: false
    end
  end
end
