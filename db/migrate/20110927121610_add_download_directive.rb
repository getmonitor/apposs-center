# coding: utf-8
class AddDownloadDirective < ActiveRecord::Migration
  def self.up

    add_column    :properties, :locked, :boolean
    
    Property.global.create :name => "profile_path", :value => '/home/lifu/conf/pe.conf'
    Property.global.create :name => "site_url", :value => 'http://127.0.0.1:9999'
  
    App.reals.each{|app|
      app.properties.create :name => :app_id, :value => app.id, :locked => true
    }
    
    Env.find_each{|e|
      e.properties.create :name => :env_id, :value => e.id, :locked => true
    }

    group = DirectiveGroup.create(:name => 'default')

    DirectiveTemplate.create(
      :name  => 'mkdir -p `dirname $profile_path` && wget "$site_url/store/$app_id/$env_id/pe.conf" -O "$profile_path" -o sync_profile.log && echo downloaded',
      :alias => 'sync_profile',
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

    App.reals.each{|app|
      app.properties.where(:name => :app_id).first.delete rescue nil
    }
    
    Env.find_each{|e|
      e.properties.where(:name => :env_id).first.delete rescue nil
    }
    
    remove_column :properties, :locked
  end
end

