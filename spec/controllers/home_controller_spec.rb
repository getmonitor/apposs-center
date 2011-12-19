# coding: utf-8
require 'spec_helper'

describe HomeController do

  render_views
  
  it "访问首页，缺省跳转至登录页" do
    get 'index'
    response.should redirect_to('/users/sign_in')
  end

end
