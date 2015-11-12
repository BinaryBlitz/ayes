# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  api_token      :string
#  gender         :string
#  birthdate      :date
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
#  device_token   :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:foo)
  end

  test 'valid' do
    assert @user.valid?
  end

  test 'gender' do
    @user.gender = 'lal'
    assert @user.invalid?

    @user.gender = 'male'
    assert @user.valid?
  end

  test 'preferred time' do
    @user.preferred_time = -1
    assert @user.invalid?

    @user.preferred_time = 23
    assert @user.valid?
  end

  test 'country' do
    @user.country = 'RUSSIA'
    assert @user.invalid?

    @user.country = 'RU'
    assert @user.valid?
  end

  test 'region' do
    @user.region = 'MOSCOW'
    assert @user.invalid?

    @user.region = 'MOW'
    assert @user.valid?
  end
end
