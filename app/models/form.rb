# == Schema Information
#
# Table name: forms
#
#  id           :integer          not null, primary key
#  gender       :string
#  age          :integer
#  city         :string
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

  validates :gender, presence: true
  validates :age, presence: true
  validates :city, presence: true
  validates :occupation, presence: true
  validates :income, presence: true
  validates :education, presence: true
  validates :relationship, presence: true
  validates :country, presence: true
  validates :region, presence: true
  validates :settlement, presence: true

  extend Enumerize

  enumerize :gender, in: [:male, :female]
  enumerize :country, in: ISO3166::Data.codes
  enumerize :region, in: ISO3166::Country.new('RU').subdivisions.keys
end
