# == Schema Information
#
# Table name: forms
#
#  id           :integer          not null, primary key
#  gender       :string
#  age          :integer
#  occupation   :string
#  income       :string
#  education    :string
#  relationship :string
#  country      :string
#  region       :string
#  settlement   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Form < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :age, presence: true
  validates :gender, presence: true
  validates :occupation, presence: true
  validates :income, presence: true
  validates :education, presence: true
  validates :relationship, presence: true
  validates :country, presence: true
  validates :region, presence: true, if: "country == 'RU'"
  validates :settlement, presence: true

  include Questionable
end
