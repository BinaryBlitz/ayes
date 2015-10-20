class Admin::AdminController < ActionController::Base
  skip_before_action :restrict_access

  layout 'admin'
end
