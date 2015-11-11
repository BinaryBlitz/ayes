class QuestionsController < ApplicationController
  def index
    @questions = Question.feed
  end
end
