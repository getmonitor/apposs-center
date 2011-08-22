class DirectiveGroupsController < ApplicationController
  def index
    render :text => DirectiveGroup.all.to_json(:include => [:directive_templates])
  end
end
