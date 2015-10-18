require 'test_helper'

class QuestionsTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:question)
  end
end
