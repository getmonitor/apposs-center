class Admin::DirectiveTemplatesController < Admin::BaseController
  def index
    directive_templates = DirectiveTemplate.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = DirectiveTemplate.count
    respond_with :totalCount => total, :directive_templates => directive_templates
  end

  def show
    respond_with DirectiveTemplate.find(params[:id])
  end

  def create
    directive_template = DirectiveTemplate.create(params[:directive_template])
    render :text => directive_template.to_json
  end

  def update
    respond_with DirectiveTemplate.find(params[:id]).update_attributes(params[:directive_template])
  end

  def destroy
    respond_with DirectiveTemplate.find(params[:id]).delete
  end
end
