# coding: utf-8
require 'fileutils'
class EnvsController < ResourceController
  
  respond_to :html

  def edit
    app = App.find( params[:app_id])
    @env = app.envs[params[:id]]
    if @env.nil? and params[:id]=='online'
      @env = app.envs.create :name => 'online'
    end
    app_props = @env.app.properties.not_lock.pairs
    env_props = @env.properties.not_lock.pairs
    @env.property_content = app_props.update( env_props ).
      collect{|k,v| "#{k}=#{v}"}.
      join("\n")
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
