class DirectivesController < BaseController

  def ack
    render :text => Directive.find(params[:id]).ack
  end
end
