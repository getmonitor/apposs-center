class Admin::RoomsController < Admin::BaseController
  def index()
    if params[:limit] && params[:page]
      respond_with Room.search(params[:limit], params[:page])
    else
      respond_with Room.all
    end
  end

  def model()
    Room
  end

  def group()
    :room
  end

  def destroy
    room = model.find(params[:id])
    if cascade?
      room.machines.each { |machine| machine.delete }
    else
      room.machines.clear
    end
    respond_with room.delete
  end
end
