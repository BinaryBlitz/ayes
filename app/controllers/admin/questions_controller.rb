class Admin::QuestionsController < Admin::AdminController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :enqueue, :publish, :up, :down]

  def index
    @questions = Question.all.tagged(params[:tag]).page(params[:page])
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
    redirect_to unpublished_admin_questions_url, notice: 'Вопрос успешно удален.'
  end

  def publish
    @question.publish
    redirect_to published_admin_questions_url, notice: 'Вопрос успешно отправлен.'
  end

  def unpublished
    @questions = Question.unpublished.order(position: :asc).tagged(params[:tag]).page(params[:page])
  end

  def scheduled
    @questions = Question.scheduled.tagged(params[:tag]).page(params[:page])
  end

  def published
    @questions = Question.published.order(published_at: :desc).tagged(params[:tag]).page(params[:page])
  end

  def up
    @question.move_higher
    redirect_to unpublished_admin_questions_path, notice: 'Приоритет повышен.'
  end

  def down
    @question.move_lower
    redirect_to unpublished_admin_questions_path, notice: 'Приоритет понижен.'
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question)
      .permit(
        :epigraph, :content, :tag_list, :published_at, :region,
        taggings_attributes: [:id, :tag_id, :_destroy]
      )
  end
end
