class MachinesController < BaseController

  def index
    machines = current_app.machines.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = current_app.machines.count

    respond_with :totalCount => total, :machines => machines
  end

  def command_state
    machine_id = params[:id]
    cmd_set_id = params[:key] if params[:key] != 'root'
    current_app = current_app()
    respond_with Machine.command_state current_app, machine_id, cmd_set_id
    #if cmd_set_id
    #  operations = current_app.cmd_sets.where(:id => cmd_set_id).first.commands.inject([]) do |operations, c|
    #    operations << c.operations.where(:machine_id => machine_id).first
    #  end.collect do |o|
    #    o.attributes.update(
    #        "id" => "#{cmd_set_id}|#{o.id}",
    #        "leaf" => true,
    #        "state" => o.human_state_name,
    #        "name" => o.command_name
    #    )
    #  end
    #  respond_with operations
    #else
    #  cmd_sets = current_app.cmd_sets.select do |cs|
    #    Machine.find(machine_id).commands.where(:cmd_set_id => cs.id).length > 0
    #  end.collect do |cs|
    #    cs.attributes.update "state" => cs.human_state_name
    #  end
    #  respond_with cmd_sets
    #end
  end

end
