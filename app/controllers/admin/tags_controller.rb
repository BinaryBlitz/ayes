class Admin::TagsController < Admin::AdminController
  before_action :set_admin_tag, only: [:show, :edit, :update, :destroy]

  def index
    @admin_tags = ActsAsTaggableOn::Tag.all
  end

  def new
    @admin_tag = ActsAsTaggableOn::Tag.new
  end

  def create
    @admin_tag = ActsAsTaggableOn::Tag.new(admin_tag_params)

    if @admin_tag.save
      redirect_to @admin_tag, notice: 'Tag was successfully created.'
    else
      render :new
    end
  end

  def update
    if @admin_tag.update(admin_tag_params)
      redirect_to @admin_tag, notice: 'Tag was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @admin_tag.destroy
    redirect_to admin_tags_url, notice: 'Tag was successfully destroyed.'
  end

  private

  def set_admin_tag
    @admin_tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def admin_tag_params
    params[:admin_tag]
  end
end
