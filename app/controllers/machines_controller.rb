class MachinesController < BaseController

  def index
    machines = current_app.machines
    if (params[:page] && params[:limit])
      total = machines.count
      respond_with Machine.search(params[:limit], params[:page], total, machines)
    else
      respond_with machines
    end
  end

end
