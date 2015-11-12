require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
  end

  test 'create' do
    post '/user.json', user: {
      gender: 'male', birthdate: Date.today, preferred_time: 0,
      settlement: 'city', country: 'US'
    }
    assert_response :created
  end

  test 'show' do
    get '/user.json', api_token: @user.api_token
    assert_response :success
  end

  test 'update' do
    patch '/user.json', user: { gender: 'female' }, api_token: api_token
    assert_response :no_content
  end

  test 'destroy' do
    delete '/user.json', api_token: api_token
    assert_response :no_content
  end
end
