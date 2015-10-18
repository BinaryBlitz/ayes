class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :api_token
      t.string :gender
      t.date :birthdate
      t.string :city
      t.string :occupation
      t.string :income
      t.string :education
      t.string :relationship
      t.integer :preferred_time
      t.string :country
      t.string :region
      t.string :settlement

      t.timestamps null: false
    end
  end
end
