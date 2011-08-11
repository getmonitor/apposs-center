class Admin::CmdGroupsController < Admin::BaseController

  def index()
    cmd_groups = CmdGroup.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = cmd_groups.count
    respond_with :totalCount => total, :cmd_groups => cmd_groups
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
