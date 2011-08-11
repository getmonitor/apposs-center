class Admin::RoomsController < Admin::BaseController
  def index()
    rooms = Room.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = rooms.count
    respond_with :totalCount => total, :rooms => rooms
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
