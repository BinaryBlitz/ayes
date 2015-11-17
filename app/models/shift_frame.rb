# == Schema Information
#
# Table name: shift_frames
#
#  id         :integer          not null, primary key
#  min_count  :integer
#  delta      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Критерий для кардинальной смены распределения
class ShiftFrame < ActiveRecord::Base
  validates :min_count, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  validates :delta, presence: true, numericality: { greater_than: 0.0 }
end
