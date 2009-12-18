require 'singleton'
require_dependency 'user_thread'
require_dependency 'private_thread'
require_dependency 'user'
require_dependency 'friendship'
require_dependency 'thread_entry'
require_dependency 'entry'
require_dependency 'comment'
require_dependency 'user_post'

class DaoHelper
  include Singleton
  
  CACHE = MemCache.new('127.0.0.1')
  
  
  def find_user_by_id(user_id)
    key = "User:" + user_id.to_s
    return self.check_object(CACHE[key], key) {User.find(user_id)}
  end
  
  def save_user(user)
    return self.save_object(user) {"User:" + user.id.to_s}
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
  
  ###
  # Please NOTE: the controller has to call this method twice with 
  # both friendship objects in order to maintain consistency.
  # E.g. user1 and user2 are now friends
  # Call the method twice with the object friendship1 and friendship2
  # the first has user_id = user1.id and friend_id = user2.id and the
  # second vice versa
  ###
  def save_friendship(friendship)
    friendships = self.find_friendships_by_userid(friendship.user_id)
    friendships.push(friendship)
    self.save_object(friendships) {"Friendships:" + friendship.user_id.to_s}
  end
  
  ##Can we delete user friendships?
  ##Can we update them?
  
  def save_userpost(post)
    userposts = self.find_userposts_by_userid(post.user_id)
    userposts.push(post)
    self.save_object(userposts) {"UserPosts:" + post.user_id.to_s}
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
  
  def save_comment(comment)
    self.save_object(comment) {"Comment:" + comment.id.to_s}
  end
  
  def save_userblock(userblock)
    userblocks = self.find_userblocks_by_userid(userblock.user_id)
    userblocks.push(userblock)
    self.save_object(userblocks) {"Userblocks:" + user_id.to_s}
  end
  
  #INSPECT
  def delete_userblock(userblock)
    userblocks = self.find_userblocks_by_userid(userblock.user_id)
    userblocks.delete(userblock)
    UserBlock.delete(:all, :condition => ["user_id= ? AND blocked_id = ?", userblock.user_id, userblock.blocked_id])
    self.save_object(userblocks)
  end
  
  def find_userblocks_by_userid(user_id)
    key = "Userblocks:" + user_id.to_s
    return self.check_object(CACHE[key], key) {UserBlock.find(:all, :condition => ["user_id = ?", user_id])}
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
    key = "UserThreads:Thread" + thread_id.to_s
    tmp_userthreads = self.check_object(CACHE[key], key) {UserThread.find(:all, :condition => ["private_thread_id = ?", thread_id])}
    tmp_users = Array.new
    tmp_userthreads.each do |ut|
      user_key = "User:" + ut.user_id.to_s
      tmp_user = self.find_user_by_id(user_key)
      tmp_users.push(tmp_user)
    end
    
    return tmp_users
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
    return self.save_object(entry) {"Entry:" + entry.id.to_s}
  end
  
  ### helper methods ###
  def check_object(object, key)
    if object == nil
      result = yield
      CACHE.set(key, result, 1.hour)
      return result
    end
    
    return object
  end
  
  def save_object(object)
    if object.save
      key = yield
      CACHE.set(key, object, 1.hour)
      return true
    else
      return false
    end
  end
  
end