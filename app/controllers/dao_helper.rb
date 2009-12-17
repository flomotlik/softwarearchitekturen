require 'singleton'
require_dependency 'user_thread'
require_dependency 'private_thread'

class DaoHelper
  include Singleton
  
  CACHE = MemCache.new('127.0.0.1')
  
  
  def find_user_by_id(user_id)
    key = "User:" + user_id.to_s
    tmp_user = CACHE[key] 
    if  tmp_user == nil
      tmp_user = User.find(user_id)
      CACHE.set(key, tmp_user, 1.hour)
    end
    
    return tmp_user
  end
  
  def save_user(user)
    if user.save
      key = "User:" + user.id.to_s
      CACHEset(key, user, 1.hour)
      return true;
    else
      return false;
    end
  end
  
  def update_user(user, attributes)
    if user.update_attributes(attributes)
      key = "User:" + user.id.to_s
      CACHE.set(key, user, 1.hour)
    end
  end
  
  def delete_user(user_id)
    key = "User:" + user_id.to_s
    CACHE.delete(key)
    User.delete(user_id)
  end
  
  def find_friendships_by_userid(user_id)
    key = "Friendships:" + user_id.to_s
    tmp_friendships = CACHE[key] 
    if  tmp_friendship == nil
      tmp_friendships = Friendship.find(:all, :condition => ["user_id = ?", user_id]) #INSPECT ME
      CACHE.set(key, tmp_friendships, 1.hour)
    end
    
    return tmp_friendships
  end
  
  
  def find_friends_by_userid(user_id)
    
  end
  
  def save_friendship(friendship)
    
  end
  
  ##Can we delete user friendships?
  ##Can we update them?
  
  def save_userpost(post)
    
  end
  
  #what is returned by this method
  #UserPost objects or PublicPost objects???
  def find_userposts_by_userid(user_id)
    
  end
  
  #is this the Comment object or the UserComment Object
  #do we need methods for both?
  def save_comment(comment)
    
  end
  
  def save_userblock(userblock)
    
  end
  
  def delete_userblock(userblock) #parameter is negotiatable
    
  end
  
  def find_userblocks_by_userid(user_id)
    
  end
  
  def find_threads_by_userid(user_id)
    key = "UserThreads:User:" + user_id.to_s
    tmp_userthreads = CACHE[key] 
    if  tmp_userthreads == nil
      tmp_userthreads = UserThread.find :all, :conditions => ["user_id = ?", user_id]
      CACHE.set(key, tmp_userthreads, 1.hour)
    end
    tmp_threads = Array.new
    for userThread in tmp_userthreads do
      key_thread = "PrivateThread:" + userThread.private_thread_id.to_s
      tmp_thread = CACHE[key_thread] 
      if  tmp_thread == nil
        tmp_thread = PrivateThread.find(userThread.private_thread_id)
        CACHE.set(key_thread, tmp_thread, 1.hour)
      end
      tmp_threads.push(tmp_thread)
    end
    return tmp_threads
  end
  
  def find_users_by_threadid(thread_id)
    
  end
  
  def save_entry(entry)
    
  end
  
  #... and some more.. please add everything you think is missing..
  #I will continue tomorrow!
  
end