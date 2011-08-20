class MachinesController < BaseController

  def index
    machines = current_app.machines.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = current_app.machines.count

    respond_with :totalCount => total, :machines => machines
  end

  def command_state
    operations = Machine.find(params[:id]).operations.collect do |o|
      o.attributes.update(
          "leaf" => true,
          "state" => o.human_state_name,
          "name" => o.command_name
      )
    end
    respond_with operations
  end

end
