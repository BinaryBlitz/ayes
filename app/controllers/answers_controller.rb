class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]

  def create
    @answer = current_user.answers.build(answer_params)

    if @answer.save
      render :show, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def similar
    question = Question.find(params[:question_id])
    @answers = Answer.similar_to(current_user.form, question)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.permit(:question_id, :value)
  end
end
