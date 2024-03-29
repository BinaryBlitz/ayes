# == Schema Information
#
# Table name: questions
#
#  id           :integer          not null, primary key
#  epigraph     :string
#  content      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  urgent       :boolean          default(FALSE)
#  published_at :datetime
#  position     :integer
#  region       :string           default("russia")
#  gender       :string           is an Array
#  occupation   :string           is an Array
#  income       :string           is an Array
#  education    :string           is an Array
#  relationship :string           is an Array
#  settlement   :string           is an Array
#  age          :integer          default([]), is an Array
#

class Question < ActiveRecord::Base
  TARGET_ATTRIBUTES = %w(age gender occupation income education relationship settlement)

  before_validation :set_age

  attr_accessor :min_age, :max_age

  has_many :answers, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :subscribers, through: :favorites, source: :user
  has_many :taggings, dependent: :destroy, inverse_of: :question
  has_many :tags, through: :taggings

  validates :content, presence: true
  validates :region, presence: true
  validates :min_age, numericality: { greater_than: 0 }, allow_blank: true
  validates :max_age, numericality: { greater_than: :min_age }, allow_blank: true
  validate :not_too_long
  validate :published_later, on: :create

  accepts_nested_attributes_for :taggings, allow_destroy: true

  extend Enumerize
  enumerize :region, in: ['russia', 'world']

  include Questionable

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

  def self.feed_for(user)
    ids = untargeted.urgent.ids + untargeted.published.ids + targeted_for(user).ids
    where(id: ids.uniq).by_country(user.country)
  end

  def self.targeted_for(user)
    questions = Question.all
    TARGET_ATTRIBUTES.each do |attribute|
      value = user.send(attribute)
      next unless value
      value = value.is_a?(Integer) ? value : "'#{value}'"
      questions = questions.where("#{value} = ANY(#{attribute}) OR #{attribute} = '{}'")
    end
    ids = questions.ids - untargeted.ids
    where(id: ids).published
  end

  def self.tagged(tag)
    questions = joins(:tags).where(tags: { name: tag })
    questions.any? ? questions : all
  end

  def self.by_country(country)
    if country == 'WORLD'
      where(region: 'world')
    else
      where(region: 'russia')
    end
  end

  def self.untargeted
    where("gender = '{}' OR gender IS NULL").where("occupation = '{}' OR occupation IS NULL")
      .where("income = '{}' OR income IS NULL")
      .where("education = '{}' OR education IS NULL")
      .where("relationship = '{}' OR relationship IS NULL")
      .where("settlement = '{}' OR settlement IS NULL")
  end

  def self.search_by(params)
    questions = Question.all
    questions = questions.where(id: params[:id]) if params[:id].present?
    questions = questions.where('content ILIKE ?', "%#{params[:content]}%") if params[:content].present?
    questions
  end

  def self.notify_distribution_changed
    Question.joins(:answers).joins(:favorites).each(&:compare_distribution)
  end

  def publish(urgent: false)
    update(urgent: urgent, published_at: Time.zone.now)
    remove_from_list
    User.notify_all(self)
  end

  def compare_distribution
    return unless yes_ratio

    subscribers.each do |subscriber|
      answer = subscriber.answers.find_by(question: self)

      if answer.significant_change?(yes_ratio)
        answer.update_distribution
        subscriber.push_distribution_shift(answer.question_id)
      end
    end
  end

  def yes_ratio
    return if answers.count == 0
    answers.positive.count.to_f / answers.where.not(value: nil).count.to_f
  end

  def published?
    urgent || published_at && published_at < Time.zone.now
  end

  def target_attributes
    attributes.slice(*TARGET_ATTRIBUTES).select { |_, attribute| attribute.any? }
  end

  def targeted?
    TARGET_ATTRIBUTES.each do |attribute|
      return true if send(attribute).any?
    end
    false
  end

  private

  def not_too_long
    return unless epigraph.present? && content.present?

    if content.length + epigraph.length > 200
      errors.add(:epigraph, 'is too long')
    end
  end

  def published_later
    return unless published_at.present?

    if published_at < Time.zone.now
      errors.add(:published_at, 'is earlier than today')
    end
  end

  def set_age
    self.min_age = min_age.to_i unless min_age.blank?
    self.max_age = max_age.to_i unless max_age.blank?
    self.age = (min_age..max_age).to_a if min_age && max_age
  end
end
