class HomeController < BaseController

  def index
    @apps = current_user.apps.uniq
    @first = @apps.first
  	render :layout => 'application'
  end

	def welcome
    respond_with current_user
	end

end
