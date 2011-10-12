class DirectivesController < ResourceController
  def force_stop
    @directive = Directive.find(params[:id])
    @directive.ok || @directive.ack
  end
end
