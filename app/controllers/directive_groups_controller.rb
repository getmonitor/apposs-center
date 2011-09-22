class DirectiveGroupsController < ApplicationController
  def index
    render :text => DirectiveGroup.all.to_json(:include => [:directive_templates])
  end
  
  def items
    @collection = DirectiveGroup.find(params[:id]).directive_templates
    respond_to do |format|
      format.js
    end
  end
end
