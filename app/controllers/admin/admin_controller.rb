class Admin::AdminController < ActionController::Base
  skip_before_action :restrict_access
  before_action :authenticate_admin!

  before_action :set_region
  def set_region
    return unless params[:region].present? #session[:region].present?
    session[:region] = params[:region]
  end

  helper_method :region
  def region
    session[:region] || 'russia'
  end

  layout 'admin'
end
