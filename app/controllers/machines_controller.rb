class MachinesController < ResourceController

#  def index
#    machines = current_app.machines.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
#    total = current_app.machines.count

#    respond_with :totalCount => total, :machines => machines
#  end

#  def command_state
#    directives = current_app.machines.find(params[:id]).directives.normal.collect do |o|
#      o.attributes.update(
#          "leaf" => true,
#          "state" => o.human_state_name,
#          "name" => o.command_name
#      )
#    end
#    respond_with directives
#  end

  def reset
    @directive = Machine.find(params[:id]).resume
  end
  
  def directives
    @directives = Machine.find(params[:id]).directives
  end
end
