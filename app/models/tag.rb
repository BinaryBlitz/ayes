# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ActiveRecord::Base
  has_many :taggings, dependent: :destroy
  has_many :questions, through: :taggings

  validates :name, presence: true

  def to_s
    "#{name}"
  end
end
