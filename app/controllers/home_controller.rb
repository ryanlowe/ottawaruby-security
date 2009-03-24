class HomeController < ApplicationController
  
  prepend_before_filter :login_required
  
  def index
    @title = "Home"
  end
  
end
