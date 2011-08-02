class MachinesController < BaseController

  def index
    machines = current_app.machines
    if (params[:start] && params[:limit])
      respond_with Machine.page(params[:start], params[:limit], machines)
    else
      respond_with machines
    end
  end

end
