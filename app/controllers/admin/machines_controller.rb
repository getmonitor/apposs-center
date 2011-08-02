class Admin::MachinesController < Admin::BaseController
  def index
    respond_with Machine.all
  end

  def show
    respond_with Machine.find(params[:id])
  end

  def create
    machine = Machine.create(params[:machine])
    render :text => machine.to_json
  end

  def update
    respond_with Machine.find(params[:id]).update_attributes(params[:machine])
  end

  def destroy
    respond_with Machine.find(params[:id]).delete
  end
end