class App < ActiveRecord::Base

  acts_as_tree

  scope :reals, where(:virtual => false, :state => 'running')

  # People
  has_many :acls, :as => :resource, :class_name => 'Stakeholder'

  has_many :operators, :through => :acls, :class_name => 'User'

  has_many :release_packs

  has_many :softwares

  # Machine
  has_many :machines

  has_many :operation_templates
  
  has_many :operations

  has_many :envs do
    def [] name
      where(:name => name).first
    end
  end

  has_many :properties, :as => :resource do
    def [] name1
      item = where(:name => name1).first
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

  # running 表示应用运行中，hold 表示暂时标记为不可用，offline 表示应用下线
  state_machine :state, :initial => :running do
    event :pause do transition :running => :hold end
    event :use do transition :hold => :running end
    event :stop do transition [:running, :hold] => :offline end
  end

end
