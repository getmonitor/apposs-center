class MachinesController < BaseController

  def index
    machines = current_app.machines.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = current_app.machines.count

    respond_with (:totalCount => total, :machines => machines)
  end

end
