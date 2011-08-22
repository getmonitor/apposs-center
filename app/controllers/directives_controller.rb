class DirectivesController < BaseController

  def index
    respond_with current_app.operations.find(params[:operation_id]).commands.find(params[:command_id]).directives
  end
end
