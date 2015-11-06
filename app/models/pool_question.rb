# == Schema Information
#
# Table name: pool_questions
#
#  id          :integer          not null, primary key
#  priority    :integer          default(0)
#  question_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class PoolQuestion < ActiveRecord::Base
  belongs_to :question

  validates :question, presence: true

  # Call this method every day
  def self.pop
    # Delete the last question
    PoolQuestion.next.try(:destroy)

    # Push the next one
    next_question = PoolQuestion.next
    return unless next_question

    User.where(preferred_time: nil).each(&:push_question)
  end

  # Call this method every hour
  def self.push_with_preferred_time
    next_question = PoolQuestion.next
    return unless next_question

    User.where(preferred_time: Time.zone.now.hour).each(&:push_question)
  end

  def self.next
    PoolQuestion.order(priority: :asc).first
  end

  def increase_priority
    next_question = PoolQuestion.where('priority <= ?', priority)
                                .where.not(id: id)
                                .order(priority: :desc).first
    update(priority: next_question.priority - 1) if next_question
  end

  def decrease_priority
    next_question = PoolQuestion.where('priority >= ?', priority)
                                .where.not(id: id)
                                .order(priority: :asc).first
    update(priority: next_question.priority + 1) if next_question
  end
end
