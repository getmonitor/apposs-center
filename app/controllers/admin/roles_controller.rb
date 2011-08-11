class Admin::RolesController < Admin::BaseController
	def index()
    roles = Role.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = roles.count
    respond_with :totalCount => total, :roles => roles
  end
	def model
		Role
	end
	def group
		:role
	end
	def destroy
		room = model.find(params[:id])
		room.delete
	end
end
