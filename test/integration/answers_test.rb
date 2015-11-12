require 'test_helper'

class AnswersTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:question)
  end

  test 'create' do
    post "/questions/#{@question.id}/answers.json", value: true, api_token: api_token
    assert_response :created
  end

  test 'similar' do
    get "/questions/#{@question.id}/answers/similar.json", api_token: api_token
    assert_response :success
  end

  test 'filter by form' do
    post "/questions/#{@question.id}/answers/forms.json", api_token: api_token, form: { id: [1, 2] }
    assert_response :success
  end
end
