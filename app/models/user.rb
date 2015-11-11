# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  api_token      :string
#  gender         :string
#  birthdate      :date
#  city           :string
#  occupation     :string
#  income         :string
#  education      :string
#  relationship   :string
#  preferred_time :integer
#  country        :string
#  region         :string
#  settlement     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  device_token   :string
#

class User < ActiveRecord::Base
  ATTRIBUTES_FOR_FORM = %i(gender age city occupation income education
    relationship country region settlement)

  has_secure_token :api_token

  has_many :answers, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorite_questions, through: :favorites, source: :question

  validates :preferred_time, inclusion: { in: 0..23 }, allow_blank: true

  include Questionable

  def self.notify_all
    User.find_each(&:push_question)
  end

  def form
    Form.find_or_create_by(attributes_for_form)
  end

  def attributes_for_form
    Hash[ATTRIBUTES_FOR_FORM.map { |arg| [arg, send(arg)] }]
  end

  def profile_complete?
    [gender, birthdate, city, occupation, income, education, relationship,
      country, region, settlement].exclude?(nil)
  end

  def push_question
    Notifier.new(self, 'Новый вопрос!', message: 'NEW_QUESTION')
  end

  private

  def age
    return 0 unless birthdate

    age = Time.zone.today.year - birthdate.year
    age -= 1 if Time.zone.today < birthdate + age.years
    age
  end
end
