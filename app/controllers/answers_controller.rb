class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      render :show, status: :created, location: @answer
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:user_id, :question_id, :value)
  end
end
