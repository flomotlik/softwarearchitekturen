class FriendsController < ApplicationController
  
  #list all friends
  def index
    @currentuser = current_user
    @currentid = @currentuser.id
    @friends = DaoHelper.instance.find_friends_by_userid(@currentid)
  end
  
  #show friend and options for blocking him
  def show
    
  end
  
  def new
    @not_friends_yet = self.populate_no_friends
  end
  
  def get_friendship(user1, user2)
    DaoHelper.instance.find_friendship_by_userids(user1, user2)
  end
  
  def add_friendships
    friend_id = params[:friend] 
    now = Time.now
    
    friendship1 = Friendship.new
    friendship1.user_id = current_user.id
    friendship1.friend = friend_id
    friendship1.date = now
    
    friendship2 = Friendship.new
    friendship2.user_id = friend_id
    friendship2.friend = current_user.id
    friendship2.date = now
    
    DaoHelper.instance.save_friendship(friendship1)
    DaoHelper.instance.save_friendship(friendship2)
    
    @not_friends_yet = self.populate_no_friends
  end
  
  def populate_no_friends
    friendships = DaoHelper.instance.find_friendships_by_userid(current_user.id)
    f_ids = Array.new
    f_ids.push(current_user.id)
    friendships.each do |f|
      f_ids.push(f.friend)
    end
    @currentuser = current_user
    return User.find(:all, :conditions => ["id NOT IN (?)", f_ids])
  end
  
end