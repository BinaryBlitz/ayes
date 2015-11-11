# == Schema Information
#
# Table name: questions
#
#  id           :integer          not null, primary key
#  epigraph     :string
#  content      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  urgent       :boolean
#  published_at :datetime
#  position     :integer
#

class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :pool_questions, dependent: :destroy

  validates :content, presence: true

  # Пул заданных вопросов
  scope :published, -> { where('published_at <= ?', Time.zone.now) }
  # Пул незаданных вопросов
  scope :unpublished, -> { where(published_at: nil) }
  # Пул вопросов вне расписания
  scope :urgent, -> { where(urgent: true) }

  acts_as_taggable
  acts_as_list

  def publish
    update_attribute(:urgent, true)
    User.find_each(&:push_question)
  end
end
