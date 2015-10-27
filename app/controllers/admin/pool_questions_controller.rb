class Admin::PoolQuestionsController < Admin::AdminController
  def index
    @pool_questions = PoolQuestion.order(priority: :asc).includes(:question).page(params[:page])
  end

  def create
    PoolQuestion.create(question_id: params[:question_id]).save!
    redirect_to admin_pool_questions_path, notice: 'Вопрос успешно добавлен в пул.'
  end

  def up
    PoolQuestion.find(params[:id]).increase_priority
    redirect_to admin_pool_questions_path, notice: 'Приоритет успешно повышен.'
  end

  def down
    PoolQuestion.find(params[:id]).decrease_priority
    redirect_to admin_pool_questions_path, notice: 'Приоритет успешно понижен.'
  end

  def destroy
    PoolQuestion.find(params[:id]).destroy
    redirect_to admin_pool_questions_path, notice: 'Вопрос успешно удален из очереди.'
  end
end
