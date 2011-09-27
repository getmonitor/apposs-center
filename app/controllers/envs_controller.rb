# coding: utf-8
class EnvsController < BaseController
  
  def upload_properties
    @env = App.find( params[:app_id]).envs['online']
  end

  def update
    @env = Env.find(params[:env][:id])
    if not @env.update_attributes( params[:env] )
      render :upload_properties
    end
  end
end
