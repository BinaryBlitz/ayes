class QuestionsController < ApplicationController
  before_action :set_question, only: [:show]

  def index
    @questions = Question.urgent
    @questions += Schedule.for_now.includes(:question).map(&:question)
    @questions += [PoolQuestion.next.question] if PoolQuestion.next
  end

  def show
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end
