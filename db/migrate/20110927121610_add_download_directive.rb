# coding: utf-8
class AddDownloadDirective < ActiveRecord::Migration
  def self.up
    Property.global["property_path"]='/home/lifu/conf/pe.conf'
    Property.global["site_url"]='http://127.0.0.1:9999'
  
    App.reals.each{|app|
      app.properties[:app_id]=app.id
    }
    
    Env.find_each{|e|
      e.properties[:env_id]=e.id
    }

    group = DirectiveGroup.create(:name => 'default')

    DirectiveTemplate.create(
      :name  => 'mkdir -p `dirname $property_path` && wget "$site_url/store/$app_id/$env_id/pe.conf" -O "$property_path"',
      :alias => 'wget_conf',
      :directive_group => group
    )
    DirectiveTemplate.create(
      :name  => 'machine|reset',
      :alias => 'machine|reset',
      :directive_group => group
    )
  end

  def self.down
    dg = DirectiveGroup.where(:name => 'default').first
    dg.directive_templates.destroy_all
    dg.delete
  end
end

