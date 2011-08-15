class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!

  respond_to :json
  layout 'admin'

  def index
    respond_with model.all
  end

  def show
    respond_with model.find(params[:id])
  end

  def create
    respond_with model.create(params[group])
  end

  def update
    respond_with model.find(params[:id]).update_attributes(params[group])
  end

  private
  def cascade?
    params[:cascade]=='true'
  end

  def model

  end

  def group

  end
end
