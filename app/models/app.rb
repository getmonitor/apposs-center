class App < ActiveRecord::Base
  # People
  has_many :stakeholders
  has_many :operators, :through => :stakeholders, :class_name => 'User'

  has_many :release_packs

  has_many :softwares

  # Machine
  has_many :machines

  has_many :operation_templates
  
  has_many :operations

  has_many :envs do
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

  def to_s
  	send :name
  end

end
