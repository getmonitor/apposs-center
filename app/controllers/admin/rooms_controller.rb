class Admin::RoomsController < Admin::BaseController
  def index
    respond_with Room.all
  end

  def show
    respond_with Room.find(params[:id])
  end

  def create
    respond_with Room.create(params[:room])
  end

  def update
    respond_with Room.find(params[:id]).update_attributes(params[:room])
  end

  def destroy
    room = Room.find(params[:id])
    if cascade?
      room.machines.each { |machine| machine.delete }
    else
      room.machines.clear
    end
    respond_with room.delete
  end

  private
  def cascade?
    params[:cascade]=='true'
  end
end
