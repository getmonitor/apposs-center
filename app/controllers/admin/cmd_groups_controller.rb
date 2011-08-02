class Admin::CmdGroupsController < Admin::BaseController

  def index()
    if params[:limit] && params[:page]
      respond_with CmdGroup.search(params[:limit], params[:page])
    else
      respond_with CmdGroup.all
    end
  end

  def model()
    CmdGroup
  end

  def group()
    :cmd_group
  end

  def destroy
    group = model.find(params[:id])
    if cascade?
      group.cmd_defs.each { |cmd_def| cmd_def.delete }
    else
      group.cmd_defs.clear
    end
    respond_with group.delete
  end
end
