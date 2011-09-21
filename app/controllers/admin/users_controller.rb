class Admin::UsersController < Admin::BaseController
  def index
    users = User.paginate(:per_page => params[:per_page], :page => params[:page])
    users = users.inject([]) do |user_infos, u|
      user_infos << u.attributes
    end
    total = User.count
    respond_with :totalCount => total, :users => users
  end

  def create
    u = User.create(params[:user])
    render :text => u.attributes.to_json
  end

  def model
    User
  end

  def group
    :user
  end
end
