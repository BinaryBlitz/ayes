class Admin::TagsController < Admin::AdminController
  before_action :set_admin_tag, only: [:show, :edit, :update, :destroy]

  def index
    @admin_tags = Tag.all
  end

  def new
    @admin_tag = Tag.new
  end

  def create
    @admin_tag = Tag.new(admin_tag_params)

    if @admin_tag.save
      redirect_to admin_tags_path, notice: 'Тег был успешно создан.'
    else
      render :new
    end
  end

  def update
    if @admin_tag.update(admin_tag_params)
      redirect_to admin_tags_path, notice: 'Тег был успешно обновлен.'
    else
      render :edit
    end
  end

  def destroy
    @admin_tag.destroy
    redirect_to admin_tags_path, notice: 'Тег был успешно удален.'
  end

  private

  def set_admin_tag
    @admin_tag = Tag.find(params[:id])
  end

  def admin_tag_params
    params.require(:tag).permit(:name)
  end
end
