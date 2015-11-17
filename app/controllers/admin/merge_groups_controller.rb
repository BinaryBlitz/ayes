class Admin::MergeGroupsController < Admin::AdminController
  def index
    @merge_groups = MergeGroup.all
  end

  def new
    @merge_group = MergeGroup.new
  end

  def create
    @merge_group = MergeGroup.new(merge_group_params)

    if @merge_group.save
      redirect_to admin_merge_groups_path, notice: 'Группа слияния создана.'
    else
      render :new
    end
  end

  def destroy
    @merge_group = MergeGroup.find(params[:id])
    @merge_group.destroy
    redirect_to admin_merge_groups_path, notice: 'Группа слияния удалена.'
  end

  def merge_group_params
    params.require(:merge_group).permit(:field, options: [])
  end
end
