class Admin::MachinesController < Admin::BaseController
  def index
    machines = Machine.all.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = Machine.all.count
    respond_with :totalCount => total, :machines => machines
    #if (params[:page] && params[:limit])
    #  total = machines.count
    #  respond_with Machine.search(params[:limit], params[:page], total, machines)
    #else
    #  respond_with machines
    #end
  end

  def show
    respond_with Machine.find(params[:id])
  end

  def create
    machine = Machine.create(params[:machine])
    render :text => machine.to_json
  end

  def update
    respond_with Machine.find(params[:id]).update_attributes(params[:machine])
  end

  def destroy
    respond_with Machine.find(params[:id]).delete
  end
end