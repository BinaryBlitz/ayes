class FormsController < ApplicationController
  before_action :set_question

  def index
    forms = Form.where(form_params).includes(:answers)
    answer_ids = []
    forms.find_each { |f| answer_ids << f.answer_ids }
    @answers = Answer.where(id: answer_ids.flatten.uniq)
  end

  private

  def form_params
    params.require(:form).permit!
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
