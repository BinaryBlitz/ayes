class Admin::QuestionsController < Admin::AdminController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :enqueue]

  def index
    @questions = Question.all.page(params[:page])
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

  def enqueue
    Pool.instance.pool_questions.create(question: @question).save
    redirect_to admin_questions_url, notice: 'Вопрос успешно добавлен в пул.'
  end

  def dequeue
    Pool.instance.questions.destroy(@question)
    redirect_to pool_admin_questions_url, notice: 'Вопрос успешно удален из пула.'
  end

  def pool
    @questions = Pool.instance.ordered_questions.page(params[:page])
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:epigraph, :content)
  end
end
