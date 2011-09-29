class DirectiveGroup < ActiveRecord::Base

  validates_uniqueness_of :name

  validates_presence_of :name

  has_many :directive_templates, :dependent => :nullify do
    def [] alias_name
      where(:alias => alias_name).first
    end

  end
  
  def self.[] name
    where(:name => name).first
  end
  
  def to_s
    name
  end
end
