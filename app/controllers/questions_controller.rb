class QuestionsController < ApplicationController
  def index
    @questions = Question.feed_for(current_user)
  end
end
