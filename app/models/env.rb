class Env < ActiveRecord::Base
  belongs_to :app

  validates_uniqueness_of :name, :scope => [:app_id]
  
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
  
  def enable_properties
    Property.global.pairs.
      update( app.properties.pairs).
      update( properties.pairs )
  end
end
