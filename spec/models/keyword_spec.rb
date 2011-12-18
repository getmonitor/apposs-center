# coding: utf-8
require 'spec_helper'

describe Keyword do
  
  it '支持关键字子类' do
    keyword = Dangerous.create :value => 'rm'
    keyword.type.should == 'Dangerous'
  end
end
