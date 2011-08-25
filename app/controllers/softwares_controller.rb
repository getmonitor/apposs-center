class SoftwaresController < BaseController
  def index
    respond_with current_app.softwares
  end

  def create
    software = current_app.softwares.create(params[:software])
    render :text => software.to_json
  end

  def destroy
    respond_with current_app.softwares.find(params[:id]).delete
  end

  def update
    respond_with current_app.softwares.find(params[:id]).update_attributes(params[:software])
  end
end