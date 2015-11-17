class Admin::ShiftFramesController < Admin::AdminController
  def index
    @shift_frames = ShiftFrame.order(min_count: :asc)
  end

  def new
    @shift_frame = ShiftFrame.new
  end

  def create
    @shift_frame = ShiftFrame.new(shift_frame_params)

    if @shift_frame.save
      redirect_to admin_shift_frames_path, notice: 'Критерий успешно создан.'
    else
      render :new
    end
  end

  def destroy
    @shift_frame = ShiftFrame.find(params[:id])
    @shift_frame.destroy
    redirect_to admin_shift_frames_path, notice: 'Критерий успешно удален.'
  end

  private

  def shift_frame_params
    params.require(:shift_frame).permit(:min_count, :delta)
  end
end
