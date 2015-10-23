# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  value       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  form_id     :integer
#

class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :form

  validates :user, presence: true
  validates :question, presence: true
end
