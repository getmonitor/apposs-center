class Admin::DirectiveGroupsController < Admin::BaseController

  def index()
    directive_groups = DirectiveGroup.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = directive_groups.count
    respond_with :totalCount => total, :directive_groups => directive_groups
  end

  def model()
    DirectiveGroup
  end

  def group()
    :directive_group
  end

  def destroy
    group = model.find(params[:id])
    if cascade?
      group.directive_templates.each { |directive_template| directive_template.delete }
    else
      group.directive_templates.clear
    end
    respond_with group.delete
  end
end
