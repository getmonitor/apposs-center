class CmdGroupsController < ApplicationController
  def index
    render :text => CmdGroup.all.to_json(:include => [:directive_templates])
  end
end
