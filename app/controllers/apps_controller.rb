class AppsController < BaseController

  def index
    respond_with current_user.apps.uniq
  end

  def show
    @app = current_user.apps.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def rooms
    respond_with(current_user.apps.find(params[:id]).machines.select([:room_id]).uniq.collect do |machine|
      Room.find(machine.room_id)
    end)
  end
end
