# == Schema Information
#
# Table name: users
#
#  id                               :integer          not null, primary key
#  api_token                        :string
#  gender                           :string
#  birthdate                        :date
#  occupation                       :string
#  income                           :string
#  education                        :string
#  relationship                     :string
#  preferred_time                   :integer
#  country                          :string
#  region                           :string
#  settlement                       :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  device_token                     :string
#  form_ids                         :integer          default([]), is an Array
#  form_id                          :integer
#  new_question_notifications       :boolean          default(TRUE)
#  favorite_questions_notifications :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  ATTRIBUTES_FOR_FORM = %w(gender age occupation income education
    relationship country region settlement)

  before_save :assign_form

  belongs_to :form

  has_secure_token :api_token

  has_many :answers, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_questions, through: :favorites, source: :question

  validates :preferred_time, inclusion: { in: 0..23 }, allow_blank: true

  include Questionable

  def self.notify_all
    User.find_each(&:push_question)
  end

  def attributes_for_form
    result = attributes.slice(*ATTRIBUTES_FOR_FORM)
    result['age'] = age
    result
  end

  def profile_complete?
    [gender, birthdate, occupation, income, education, relationship,
      country, region, settlement].exclude?(nil)
  end

  def push_question
    return unless new_question_notifications
    Notifier.new(self, 'Новый вопрос!', message: 'NEW_QUESTION')
  end

  def push_distribution_shift
    return unless favorite_questions_notifications
    Notifier.new(self, 'Изменение распределения вопроса.', message: 'DISTRIBUTION_SHIFT')
  end

  private

  def age
    return unless birthdate

    age = Time.zone.today.year - birthdate.year
    age -= 1 if Time.zone.today < birthdate + age.years
    age
  end

  def assign_form
    return unless profile_complete?

    form = Form.find_or_create_by(attributes_for_form)
    self.form_ids << form.id unless form.id && form_ids.include?(form.id)
    self.form = form
  end
end
