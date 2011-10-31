class ResourceController < InheritedResources::Base

  before_filter :authenticate_user!

  respond_to :js,:xml

  def current_app
    current_user.apps.where(:id => params[:app_id]).first||App.new
  end
  
  def event
    @result = resource.send params[:event].to_sym
  end
  
  protected
    def begin_of_association_chain
      @current_user
    end

end
