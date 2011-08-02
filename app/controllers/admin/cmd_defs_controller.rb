class Admin::CmdDefsController < Admin::BaseController
  def index
    cmd_defs = CmdDef.all
    if params[:page] && params[:limit]
      total = cmd_defs.count
      respond_with CmdDef.search(params[:limit], params[:page], total)
    else
      respond_with cmd_defs
    end
  end

  def show
    respond_with CmdDef.find(params[:id])
  end

  def create
    cmd_def = CmdDef.create(params[:cmd_def])
    render :text => cmd_def.to_json
  end

  def update
    respond_with CmdDef.find(params[:id]).update_attributes(params[:cmd_def])
  end

  def destroy
    respond_with CmdDef.find(params[:id]).delete
  end
end
