class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites
  end

  def create
    @favorite = current_user.favorites.build(favorite_params)

    if @favorite.save
      render :show, status: :created
    else
      render json: @favorite.errors, status: 422
    end
  end

  private

  def favorite_params
    params.permit(:question_id)
  end
end
