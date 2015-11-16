# == Schema Information
#
# Table name: merge_groups
#
#  id         :integer          not null, primary key
#  field      :string
#  options    :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MergeGroup < ActiveRecord::Base
  validates :field, presence: true
  validates :options, length: { minimum: 1 }
  validate :valid_field_options
  validate :mutually_exclusive_options

  extend Enumerize
  enumerize :field, in: %w(gender occupation income age education relationship settlement)

  def self.options_for_form
    (field.values - ['age']).map { |field| User.send(field).values }
  end

  private

  # All options exist in the corresponding field
  def valid_field_options
    return unless field

    errors.add(:options, 'are invalid') if (options - User.send(field).values).any?
  end

  def mutually_exclusive_options
    return unless field && options

    MergeGroup.where(field: field).each do |group|
      errors.add(:options, 'intersect') if (group.options & options).any?
    end
  end
end
