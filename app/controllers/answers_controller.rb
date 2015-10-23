class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :update, :destroy]

  def create
    @answer = current_user.answers.build(answer_params)

    if current_user.profile_complete?
      form = Form.find_or_create_by(current_user.attributes_for_form)
      @answer.form = form
    end

    if @answer.save
      render :show, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.permit(:question_id, :value)
  end
end
