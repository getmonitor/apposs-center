# coding: utf-8
require 'spec_helper'

describe HomeController do

  render_views
  
  describe "访问首页，缺省跳转至登录页" do
    it "should redirect_to login" do
      get 'index'
      response.should redirect_to('/users/sign_in')
    end
  end

end
