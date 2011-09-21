class AppsController < BaseController

  def index
    respond_with current_user.apps.reals.uniq
  end

  def show
    respond_with current_user.apps.find(params[:id])
  end

  def rooms
    respond_with(current_user.apps.find(params[:id]).machines.select([:room_id]).uniq.collect do |machine|
      Room.find(machine.room_id)
    end)
  end
end
