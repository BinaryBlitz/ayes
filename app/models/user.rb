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
#

class User < ActiveRecord::Base
  has_secure_token :api_token

  has_many :answers, dependent: :destroy

  validates :preferred_time, inclusion: { in: 0..23 }, allow_blank: true

  extend Enumerize

  enumerize :gender, in: [:male, :female]
  enumerize :country, in: ISO3166::Data.codes
  enumerize :region, in: ISO3166::Country.new('RU').subdivisions.keys
end
