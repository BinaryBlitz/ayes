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

  extend Enumerize
  enumerize :field, in: %w(gender occupation income age education relationship settlement)

  private

  # All options exist in the corresponding field
  def valid_field_options
    return unless field

    errors.add(:options, 'are invalid') if (options - User.send(field).values).any?
  end
end
