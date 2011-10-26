# coding: utf-8
require 'tool/app_load.rb'
class AppsController < BaseController

  def index
    respond_with current_user.apps.reals.uniq
  end

  def show
    @app = current_user.apps.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  

  def operations
    @app = current_user.apps.find(params[:id])
    @collection = @app.operations.without_state(:done)
    respond_to do |format|
      format.js
    end
  end

  def old_operations
    @app = current_user.apps.find(params[:id])
    @collection = @app.operations.where(:state => :done)
    respond_to do |format|
      format.js
    end
  end
  
  def reload_machines
    @app = current_user.apps.find(params[:id])
    Tool::AppLoad.new([]).do_load @app.id
    respond_to do |format|
      format.js
    end
  end
end
