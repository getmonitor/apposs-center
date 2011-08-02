class Admin::MachinesController < Admin::BaseController
  def index
    machines = Machine.all
    if (params[:page] && params[:limit])
      total = machines.count
      respond_with Machine.search(params[:limit], params[:page], total, machines)
    else
      respond_with machines
    end
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