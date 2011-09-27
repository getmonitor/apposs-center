class Env < ActiveRecord::Base
  belongs_to :app
  
  has_many :machines

  validates_uniqueness_of :name, :scope => [:app_id]
  
  attr_accessor :property_file, :property_content
  
  before_save :check_for_property
  
  has_many :properties, :as => :resource do
    def [] name
      item = where(:name => name).first
      item.value if item
    end

    def []=name,value
      item = where(:name => name).first
      if item.nil?
        new(:name => name, :value => value).save!
      else
        item.update_attribute(:value, value) && item
      end
    end

    def pairs
      all.inject({}){|hash,env| hash.update(env.name => env.value) }
      end
  end
  
  def check_for_property
    if self.property_file
      data = property_file.read
      reload_property_data(data)
    else
      Rails.logger.info 'no property file'
    end

    if self.property_content
      reload_property_data self.property_content
    end
  end

  def enable_properties
    Property.global.pairs.
      update( app.properties.pairs).
      update( properties.pairs )
  end
  
  def reload_property_data data
    self.properties.destroy_all
    data.split( "\n" ).each{|line|
      k,v = line.split('=')
      self.properties[k]=v if v
    }
  end

  def download_properties
    data = Property.build_property enable_properties
    if block_given?
      yield data
    end

    machines.each{|m|
      DirectiveGroup['default'].directive_templates['download'].gen_directive(
          :room_id => m.room.id,
          :room_name => m.room.name,
          :machine_host => m.host,
          :machine => m
      )
    }
  end
end
