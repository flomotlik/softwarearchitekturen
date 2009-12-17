require 'singleton'
require_dependency 'user_thread'
require_dependency 'private_thread'
require_dependency 'user'
require_dependency 'friendship'
require_dependency 'thread_entry'
require_dependency 'entry'

class DaoHelper
  include Singleton
  
  CACHE = MemCache.new('127.0.0.1')
  
  
  def find_user_by_id(user_id)
    key = "User:" + user_id.to_s
    return self.check_object(CACHE[key], key) {User.find(user_id)}
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
    return self.check_object(CACHE[key], key) {Friendship.find(:all, :condition => ["user_id = ?", user_id])}
  end
  
  
  def find_friends_by_userid(user_id)
    friendships = self.find_friendships_by_userid(user_id)
    friends = Array.new
    friendships.each do |f|
      friends.push(self.find_user_by_id(f.friend_id))
    end
    
    return friends
  end
  
  def save_friendship(friendship)
    # not sure what to do here...
    # get all friendships of user with id friendship.user_id
    # push this friendship to his friendships
    # than do the same for the other direction
    # or just save the friendship... will be inconsistent
  end
  
  ##Can we delete user friendships?
  ##Can we update them?
  
  def save_userpost(post)
    
  end
  
  def find_userposts_by_userid(user_id)
    key = "UserPosts:" + user_id.to_s
    return self.check_object(CACHE[key], key) {UserPost.find(:all, :condition => ["user_id=?", user_id])}
  end
  
  def find_publicposts_by_userid(user_id)
    userposts = self.find_userposts_by_userid(user_id)
    posts = Array.new
    userposts.each do |p|
      posts.push(self.find_publicpost_by_id(p.post_id))
    end
  end
  
  def find_publicpost_by_id(post_id)
    key = "PublicPost:" + post_id.to_s
    return self.check_object(CACHE[key], key) {PublicPost.find(post_id)}
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
    tmp_userthreads = self.check_object(CACHE[key], key) {UserThread.find :all, :conditions => ["user_id = ?", user_id]} 
    
    tmp_threads = Array.new
    for userThread in tmp_userthreads do
      key_thread = "PrivateThread:" + userThread.private_thread_id.to_s
      tmp_thread = self.check_object(CACHE[key_thread], key_thread) {PrivateThread.find(userThread.private_thread_id)} 
      tmp_threads.push(tmp_thread)
    end
    return tmp_threads
  end
  
  def find_users_by_threadid(thread_id)
    
  end
  
  def find_thread(thread_id)
    key = "PrivateThreads:" + thread_id.to_s
    return self.check_object(CACHE[key], key) {PrivateThread.find(thread_id)}
  end
  
  def find_thread_entries_by_threadid(thread_id)
    key = "ThreadEntry:PrivateThread:" + thread_id.to_s
    return self.check_object(CACHE[key], key) {ThreadEntry.find :all, :conditions => ["thread_id = ?", thread_id]}
  end
  
  def find_entry(entry_id)
    key = "Entry:" + entry_id.to_s
    return self.check_object(CACHE[key], key) {Entry.find(entry_id)}
  end
  
  def save_entry(entry)
    
  end
  
  def check_object(object, key)
    if object == nil
      result = yield
      CACHE.set(key, result, 1.hour)
      return result
    end
    
    return object
  end
  
end