class Admin::SchedulesController < Admin::AdminController
  def new
    @schedule = Schedule.new(question_id: params[:question_id])
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      redirect_to [:admin, @schedule.question], notice: 'Вопрос успешно запланирован.'
    else
      render action: 'new', question_id: params[:question_id]
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:scheduled_for, :question_id)
  end
end
