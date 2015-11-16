class Admin::MergeGroupsController < Admin::AdminController
  def index
    @merge_groups = MergeGroup.all
  end

  def new
    @merge_group = MergeGroup.new
  end

  def destroy
    @merge_group.destroy
  end
end
