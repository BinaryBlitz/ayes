require 'test_helper'

class QuestionsTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:question)
  end

  test 'list' do
    get '/questions.json', api_token: api_token
    assert_response :success
  end
end
