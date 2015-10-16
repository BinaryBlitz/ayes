class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def show
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user)
          .permit(
            :api_token, :gender, :birthdate,
            :city, :occupation, :income, :education,
            :relationship, :preferred_time, :country, :region
          )
  end
end
