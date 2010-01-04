class FriendsController < ApplicationController
  
  #list all friends
  def index
    @friends = DaoHelper.instance.find_friends_by_userid(self.get_currentusers_id)
  end
  
  def get_currentusers_id
  @currentuser = current_user
  @currentid = @currentuser.id
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
  
  def block_friend
    friend_id = params[:friend]
    
    block = UserBlock.new
    block.user_id = current_user.id
    block.blocked_id = friend_id
    block.date = Time.now
    
    DaoHelper.instance.save_userblock(block)
    @friends = DaoHelper.instance.find_friends_by_userid(current_user.id)
    puts @friends.size
  end
  
  def unblock_friend
    friend_id = params[:friend]
    
    userblocks = DaoHelper.instance.find_userblocks_by_userid(current_user.id)
    
    block = nil
    userblocks.each do |ub|
      if ub.blocked_id.to_s == friend_id.to_s
        block = ub
      end
    end
    
    if block == nil
      raise "BLOCK EXCEPTION"
    else
      DaoHelper.instance.delete_userblock(block)
      @friends = DaoHelper.instance.find_friends_by_userid(current_user.id)
    end
  end
  
  def is_friend_blocked(friend_id)
    userblocks = DaoHelper.instance.find_userblocks_by_userid(current_user.id)
    
    userblocks.each do |ub| 
      if (ub.blocked_id == friend_id)
        return true
      end
    end
    
    return false
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