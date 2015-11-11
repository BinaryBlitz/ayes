class QuestionsController < ApplicationController
  def index
    @questions = Question.urgent
    @questions += Schedule.for_now.includes(:question).map(&:question)
    @questions += [PoolQuestion.next.question] if PoolQuestion.next.try(:question)
  end
end
