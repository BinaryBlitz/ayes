require 'test_helper'

class FavoritesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foo)
    @question = questions(:question)
  end

  test 'list' do
    @user.favorite_questions << @question
    get '/favorites.json', api_token: api_token
    assert_response :success
  end

  test 'create' do
    assert_difference 'Favorite.count' do
      post '/favorites.json', api_token: api_token, question_id: @question.id
      assert_response :created
    end
    assert_includes @user.favorite_questions, @question
  end
end
