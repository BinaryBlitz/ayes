# == Schema Information
#
# Table name: schedules
#
#  id            :integer          not null, primary key
#  question_id   :integer
#  scheduled_for :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Schedule < ActiveRecord::Base
  belongs_to :question

  validates :question, presence: true
  validates :scheduled_for, presence: true

  scope :for_today, -> { where(scheduled_for: (Time.zone.now - 24.hours)..Time.zone.now) }
  scope :for_now, -> { where(scheduled_for: Time.zone.now..(Time.zone.now + 1.hour)) }

  def self.push_scheduled_questions
    User.all.each(&:push_question) if for_now.any?
  end
end
