class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.string :gender
      t.integer :age
      t.string :city
      t.string :occupation
      t.string :income
      t.string :education
      t.string :relationship
      t.string :country
      t.string :region
      t.string :settlement

      t.timestamps null: false
    end
  end
end
