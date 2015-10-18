# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  epigraph   :string
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :epigraph, presence: true
  validates :content, presence: true
end
