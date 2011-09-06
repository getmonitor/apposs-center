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
    def [] key
      item = where(:key => key).first
      item.value if item
    end

    def []=key,value
      item = where(:key => key).first
      if item.nil?
        new(:key => key, :value => value).save!
      else
        item.update_attribute(:value, value) && item
      end
    end
  end

  def to_s
  	send :name
  end

end
