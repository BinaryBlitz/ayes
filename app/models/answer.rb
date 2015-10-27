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
  before_save :set_form

  belongs_to :user
  belongs_to :question
  belongs_to :form

  validates :user, presence: true
  validates :question, presence: true

  scope :positive, -> { where(value: true) }
  scope :negative, -> { where(value: false) }
  scope :neutral, -> { where(value: nil) }

  private

  def set_form
    return unless user.profile_complete?

    self.form = Form.find_or_create_by(user.attributes_for_form)
  end
end
