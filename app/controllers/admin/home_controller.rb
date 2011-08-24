class Admin::HomeController < Admin::BaseController
  def index
    if !current_user.is_admin?
      redirect_to root_path
    end
  end
end