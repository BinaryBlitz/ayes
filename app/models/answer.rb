# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  value       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  form_id     :integer
#  yes_ratio   :float
#  total_count :integer
#  compared_at :datetime
#

class Answer < ActiveRecord::Base
  before_save :set_form

  belongs_to :user
  belongs_to :question
  belongs_to :form

  validates :user, presence: true
  validates :question, presence: true

  scope :positive, -> { where(value: true) }
  scope :negative, -> { where(value: false) }
  scope :neutral, -> { where(value: nil) }

  DEFAULT_DELTA = 0.5

  def to_csv_value
    case value
    when false then '2'
    when true then '1'
    when nil then 'na'
    else nil
    end
  end

  def self.similar_to(form, question)
    return none unless form
    forms = Form.where(age: form.age_range, gender: form.gender)

    MergeGroup::MERGE_ATTRIBUTES.each do |attribute|
      merge_group = MergeGroup.find_by(field: attribute)
      next unless merge_group

      forms = forms.where(attribute => merge_group.options)
    end

    where(form: forms, question: question)
  end

  def significant_change?(question_ratio)
    update_distribution and return unless yes_ratio
    (question_ratio - yes_ratio).abs > min_delta
  end

  def update_distribution
    update(
      yes_ratio: question.yes_ratio,
      total_count: question.answers.count,
      compared_at: Time.zone.now
    )
  end

  private

  def set_form
    return unless user.profile_complete?

    self.form = Form.find_or_create_by(user.attributes_for_form)
  end

  def min_delta
    frame = ShiftFrame.for_count(total_count).first
    frame.try(:delta) || DEFAULT_DELTA
  end
end
