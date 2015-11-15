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
#  region       :string           default("russia")
#

class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :taggings, dependent: :destroy, inverse_of: :question
  has_many :tags, through: :taggings

  validates :content, presence: true
  validates :region, presence: true
  validate :not_too_long

  accepts_nested_attributes_for :taggings, allow_destroy: true

  extend Enumerize
  enumerize :region, in: ['russia', 'world']

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
  # scope :next, -> { unpublished.order(position: :asc).limit(1) }

  scope :by_region, -> (region) { where(region: region) if region }

  acts_as_list

  def self.feed_for(current_user)
    ids = Question.urgent.ids + Question.for_today.ids
    Question.where(id: ids.uniq).by_country(current_user.country)
  end

  def self.tagged(tag)
    questions = joins(:tags).where(tags: { name: tag })
    questions.any? ? questions : all
  end

  def self.by_country(country)
    if country.blank? || country == 'RU'
      where(region: 'russia')
    else
      where(region: 'world')
    end
  end

  def self.search_by(params)
    questions = Question.all
    questions = questions.where(id: params[:id]) if params[:id].present?
    questions = questions.where('content ILIKE ?', "%#{params[:content]}%") if params[:content].present?
    questions
  end

  def publish
    update(urgent: true, published_at: Time.zone.now)
    remove_from_list
    User.find_each(&:push_question)
  end

  private

  def not_too_long
    return unless epigraph.present? && content.present?

    if content.length + epigraph.length > 200
      errors.add(:epigraph, 'is too long')
    end
  end
end
