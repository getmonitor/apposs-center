class ResourceController < InheritedResources::Base

  before_filter :authenticate_user!

  respond_to :js

  def current_app
    current_user.apps.where(:id => params[:app_id]).first||App.new
  end
  
  protected
    def begin_of_association_chain
      @current_user
    end

end
