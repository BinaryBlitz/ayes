class AddFormIdToAnswers < ActiveRecord::Migration
  def change
    add_reference :answers, :form, index: true
  end
end
