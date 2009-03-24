module ProfileHelper
  def link_profile(user)
    link_to h(user.username), :controller => 'profile', :action => 'user', :username => user.username
  end
end
