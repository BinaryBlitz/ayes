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
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :content, presence: true

  accepts_nested_attributes_for :taggings, allow_destroy: true

  # Пул заданных вопросов
  scope :published, -> { where('published_at <= ?', Time.zone.now) }
  # Пул незаданных вопросов
  scope :unpublished, -> { where(published_at: nil) }
  # Пул вопросов вне расписания
  scope :scheduled, -> { where('published_at > ?', Time.zone.now) }
  # Пул отправленных сейчас
  scope :urgent, -> { where(urgent: true) }
  # Вопросы на сегодня
  scope :for_today, -> { where(published_at: 1.day.ago..Time.zone.now) }
  # Следующий из очереди
  scope :next, -> { unpublished.order(position: :asc).limit(1) }

  acts_as_list

  def self.feed
    ids = Question.urgent.ids + Question.for_today.ids + Question.next.ids
    Question.where(id: ids.uniq)
  end

  def self.tagged(tag)
    questions = joins(:tags).where(tags: { name: tag })
    questions.any? ? questions : all
  end

  def publish
    update(urgent: true, published_at: Time.zone.now)
    remove_from_list
    User.find_each(&:push_question)
  end
end
