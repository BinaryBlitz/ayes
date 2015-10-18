require 'test_helper'

class AnswersTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:question)
  end

  test 'create' do
    post "/questions/#{@question.id}/answers.json", value: true, api_token: api_token
    assert_response :created
  end
end
