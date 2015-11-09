class Admin::QuestionsController < Admin::AdminController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :enqueue, :urgent]

  def index
    @questions = Question.all.page(params[:page])
    @questions = @questions.tagged_with(params[:tag]) if params[:tag].present?
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to [:admin, @question], notice: 'Вопрос успешно создан.'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to [:admin, @question], notice: 'Вопрос успешно обновлен.'
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_questions_url, notice: 'Вопрос успешно удален.'
  end

  def urgent
    @question.push_now
    redirect_to admin_questions_url, notice: 'Вопрос успешно отправлен.'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:epigraph, :content, :tag_list)
  end
end
