class Admin::AdminController < ActionController::Base
  skip_before_action :restrict_access
  before_action :authenticate_admin!

  layout 'admin'
end
