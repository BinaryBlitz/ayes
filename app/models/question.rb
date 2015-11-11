# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  epigraph   :string
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  urgent     :boolean
#

class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  has_many :favorites, dependent: :destroy

  has_many :pool_questions, dependent: :destroy

  validates :content, presence: true

  scope :urgent, -> { where(urgent: true) }

  acts_as_taggable

  def push_now
    update_attribute(:urgent, true)
    User.find_each(&:push_question)
  end
end
