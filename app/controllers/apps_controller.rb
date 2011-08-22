class AppsController < BaseController

  def index
    respond_with current_user.apps
  end

  def show
    respond_with current_user.apps.find(params[:id])
  end

  def operations
    respond_with current_app.operations
  end
end
