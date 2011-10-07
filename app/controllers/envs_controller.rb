# coding: utf-8
require 'fileutils'
class EnvsController < ResourceController
  
  respond_to :html

  def edit
    @env = App.find( params[:app_id]).envs[params[:id]]
  end

  def update
    env = App.find( params[:app_id]).envs[params[:id]]
    if env.nil?
      env = App.find(params[:app_id]).envs.create :name => params[:id]
    elsif env.update_attributes( params[:env] )
      env.sync_profile do |data|
        file_folder = "#{Rails.root}/public/store/#{env.app.id}/#{env.id}"
        FileUtils.mkdir_p file_folder unless File.exist? file_folder
        File.open("#{file_folder}/pe.conf","w"){|f| f.write data }
      end
    else
      render :upload_properties
    end
  end
end
