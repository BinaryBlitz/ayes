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
