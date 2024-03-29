class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :restrict_access
  attr_reader :current_user
  helper_method :current_user

  def restrict_access
    unless restrict_access_by_params
      render json: { message: 'Invalid API Token' }, status: :unauthorized
      return
    end
  end

  def restrict_access_by_params
    return true if @current_user

    @current_user = User.find_by_api_token(params[:api_token])
  end

  # Devise configuration
  skip_before_action :restrict_access, if: :devise_controller?
  layout :set_layout

  helper_method :region
  def region
    session[:region] || 'russia'
  end

  protected

  def set_layout
    devise_controller? ? 'admin' : false
  end
end
