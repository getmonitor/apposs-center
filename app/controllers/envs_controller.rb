# coding: utf-8
require 'fileutils'
class EnvsController < BaseController
  
  def upload_properties
    @env = App.find( params[:app_id]).envs['online']
  end

  def update
    @env = Env.find(params[:env][:id])
    if not @env.update_attributes( params[:env] )
      render :upload_properties
    else
      @env.download_properties do |data|
        file_folder = "#{Rails.root}/public/store/#{env.app.id}/#{env.id}"
        FileUtils.mkdir_p file_folder unless File.exist? file_folder
        File.open("#{file_folder}/pe.conf","w"){|f| f.write data }
      end
    end
  end
end
