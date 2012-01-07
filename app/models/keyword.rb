class Keyword < ActiveRecord::Base
  acts_as_taggable
#  self.abstract_class = true
  validates_presence_of :type
  
  def self.words
    select(:value).all.collect(&:value)
  end
end
