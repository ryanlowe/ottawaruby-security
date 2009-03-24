class ProfileController < ApplicationController

  def user
    @user = User.find_by_username(params[:username])
    raise ActiveRecord::RecordNotFound if @user.nil?
    @title = @user.username
  end

  def list
    @users = User.find(:all, :order => 'username ASC')
    @title = "People"
  end

end
