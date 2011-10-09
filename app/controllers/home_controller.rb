class HomeController < BaseController

  def index
    @apps = current_user.apps
  	render :layout => 'application'
  end

	def welcome
    respond_with current_user
	end

  def event
    @directive = Directive.find(params[:id])
    @result = @directive.send params[:event].to_sym
  end
end
