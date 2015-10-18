require 'test_helper'

class AuthTest < ActionDispatch::IntegrationTest
  test 'restricts access without api token' do
    get '/questions.json'
    assert_response :unauthorized
  end

  test 'allows users to sign up without api token' do
    post '/user.json', user: { gender: 'male' }
    assert_response :success
  end
end
