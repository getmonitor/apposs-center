class Env < ActiveRecord::Base
  belongs_to :app

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
end
