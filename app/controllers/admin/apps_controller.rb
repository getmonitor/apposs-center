class Admin::AppsController < Admin::BaseController

  def update_resource(object, attributes)
    attributes[:machines] = Machine.where(:id => attributes[:machines])
    attributes[:directive_groups] = DirectiveGroup.where(:id => attributes[:directive_groups])
    object.update_attributes(attributes)
  end

  def index
    apps = App.reals.paginate(:per_page => params[:per_page].to_i, :page => params[:page].to_i)
    total = App.reals.count
    respond_with :totalCount => total, :apps => apps
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
      respond_with App.create(params[:app].update(:virtual => false))
    end
  end

  def destroy
    if params[:user_id] && params[:role_id]
      respond_with Stakeholder.where(:app_id => params[:id].to_i, :user_id => params[:user_id].to_i, :role_id => params[:role_id].to_i).delete_all
    else
      respond_with App.find(params[:id]).delete
    end
  end

  def update_app_user_role
    respond_with Stakeholder.find(params[:stakeholder_id]).update_attributes(:app_id => params[:id],:user_id => params[:user_id],:role_id => params[:role_id])
  end

  def model
    App
  end

  def group
    :app
  end

end
