class FriendsController < ApplicationController
  
  #list all friends
  def index
    @currentuser = current_user
    id = @currentuser.id
    @friends = DaoHelper.instance.find_friends_by_userid(id)
    
    @friendships = DaoHelper.instance.find_friendships_by_userid(id)
    
    
  end
  
  #show friend and options for blocking him
  def show
    
  end
  
  def add
    
  end
  
end