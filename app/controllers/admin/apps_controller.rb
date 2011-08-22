class Admin::AppsController < Admin::BaseController

  def update_resource(object, attributes)
    attributes[:machines] = Machine.where(:id => attributes[:machines])
    attributes[:directive_groups] = DirectiveGroup.where(:id => attributes[:directive_groups])
    object.update_attributes(attributes)
  end

  def index
    apps = App.all
    respond_with apps
  end

  def show
    records = []
    Stakeholder.where(:app_id => params[:id]).collect do |record|
      records << record.attributes.update(
          'user' => User.find(record.user_id).email,
          'role' => Role.find(record.role_id).name
      )
    end
    respond_with records
  end

  def create
    if params[:dispatch_to_user]
      s = Stakeholder.create(:app_id => params[:app_id], :user_id => params[:user_id], :role_id => params[:role_id])
      render :text => {"errors" => s.errors}.to_json
    else
      respond_with App.create(params[:app])
    end
  end

  def destroy
    if params[:user_id] && params[:role_id]
      respond_with Stakeholder.where(:app_id => params[:id].to_i, :user_id => params[:user_id].to_i, :role_id => params[:role_id].to_i).delete_all
    else
      respond_with App.find(params[:id]).delete
    end
  end

  def model
    App
  end

  def group
    :app
  end

end
