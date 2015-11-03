# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  epigraph   :string
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  urgent     :boolean
#

class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :epigraph, presence: true
  validates :content, presence: true

  def push_now
    update(urgent: true)
    User.all.each(&:push_question)
  end
end
