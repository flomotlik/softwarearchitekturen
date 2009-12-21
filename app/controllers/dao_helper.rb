require 'singleton'
require_dependency 'user_thread'
require_dependency 'private_thread'
require_dependency 'user'
require_dependency 'friendship'
require_dependency 'thread_entry'
require_dependency 'entry'
require_dependency 'comment'
require_dependency 'user_post'
require_dependency 'post'
require_dependency 'post_comment'
require_dependency 'notification'
require_dependency 'user_block'

class DaoHelper
  include Singleton
  
  CACHE = MemCache.new('127.0.0.1')
  
  
  def find_user_by_id(user_id)
    key = "User:" + user_id.to_s
    return self.check_object(CACHE[key], key) {User.find(user_id)}
  end
  
  ######## 
  ## COMMENTS
  def find_postcomment_by_postid(post_id)
    key = "PostComments:User:" + user_id.to_s
    return self.check_object(CACHE[key], key) {PostComment.find(:all, :conditions => ["comment_id = ?", comment_id])}
  end
  
  ## save
  def save_comment(comment)
    return self.save_object(comment) {"Comment:" + comment.id.to_s}
  end
  
  # def save_comment(comment)
  #   self.save_object(comment) {"Comment:" + comment.id.to_s}
  # end
  
  
  def save_postcomment(saved_comment, post_id)
    post_comment = PostComment.new
    post_comment.post_id = post_id
    post_comment.comment_id = saved_comment.id
    post_comment.save
    post_comment_mem_key = "PostComment:Comment:" + post_comment.comment_id.to_s
    CACHE.delete(post_comment_mem_key)
    #return self.save_object(comment) {"Comment:" + comment.id.to_s}
  end
  
  def save_new_comment(comment, post)
    post_id = post.id
    comment.date = Time.now
    saved_comment = self.save_comment(comment)
    self.save_postcomment(saved_comment, post_id)
    return saved_comment
  end
  
  def find_comment_by_id(comment_id)
    key = "Comment:" + comment_id.to_s
    return self.check_object(CACHE[key], key) {Comment.find(comment_id)}
  end
  
  def find_comments_by_user_id(user_id)
    key = "Comments:User:" + user_id.to_s
    return self.check_object(CACHE[key], key) {Comment.find(:all, :conditions => ["user_id = ?", user_id])}
  end
  
  #########
  
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
  
  def find_notifications_by_userid(user_id)
    key = "Notifications:" + user_id.to_s
    return self.check_object(CACHE[key], key) {Notification.find(:all, :conditions => ["user_id = ?", user_id])}
  end
  
  def save_notification(n)
    n.save
    CACHE.delete("Notifications:" + n.user_id.to_s)
  end
  
  def find_friendships_by_userid(user_id)
    key = "Friendships:" + user_id.to_s
    return self.check_object(CACHE[key], key) {Friendship.find(:all, :conditions => ["user_id = ?", user_id])}
  end
  
  def find_friendship_by_userids(user1, user2)
    friendship = Friendship.find(:first, :conditions => ["user_id = ? AND friend = ?", user1, user2]) 
  end
  
  def find_friends_by_userid(user_id)
    friendships = self.find_friendships_by_userid(user_id)
    friends = Array.new
    friendships.each do |f|
      friends.push(self.find_user_by_id(f.friend))
    end
    
    return friends
  end
  
  def save_friendship(friendship)
    friendship.save
    
    CACHE.delete("Friendships:" + friendship.user_id.to_s)
  end
  
  ##Can we delete user friendships?
  ##Can we update them?
  
  ## POSTS
  ## save
  def save_post(post)
    return self.save_object(post) {"Post:" + post.id.to_s}
  end
  
  def save_userpost(saved_post )
    user_post = UserPost.new
    user_post.post_id = saved_post.id
    user_post.user_id = saved_post.user_id
    user_post.save
    user_post_mem_key = "UserPosts:User:" + saved_post.user_id.to_s
    CACHE.delete(user_post_mem_key)
    
    # userposts = self.find_userposts_by_userid(post.user_id)
    # userposts.push(post)
    # self.save_object(userposts) {"UserPosts:" + post.user_id.to_s}
  end
  
  # saves user_post and post
  def save_new_post(post)
    post.date = Time.now
    saved_post = self.save_post(post)
    self.save_userpost(saved_post)
  end
  
  ## find
  def find_userposts_by_userid(user_id)
    key = "UserPosts:User:" + user_id.to_s
    return self.check_object(CACHE[key], key) {UserPost.find(:all, :conditions => ["user_id=?", user_id])}
  end

  def find_userpost_by_post_id(post_id)
    key = "UserPost:Post:" + post_id.to_s
    return self.check_object(CACHE[key], key) {UserPost.find(:first, :conditions => ["post_id = ?", post_id])}
  end

  def find_post_by_id(post_id)
    key = "Post:" + post_id.to_s
    return self.check_object(CACHE[key], key) {Post.find(post_id)}
  end
  
  def find_post_by_id(post_id)
     key = "Post:" + post_id.to_s
     return self.check_object(CACHE[key], key) {Post.find(post_id)}
  end
  
  def find_posts_by_userid(user_id)
    user_posts = self.find_userposts_by_userid(user_id)
    
    posts = Array.new
    user_posts.each do |p|
      posts.push(self.find_post_by_id(p.post_id))
    end    
    return posts
  end
  
  # def find_posts_by_userid(user_id)
  #     userposts = self.find_userposts_by_userid(user_id)
  #     posts = Array.new
  #     userposts.each do |p|
  #       posts.push(self.find_post_by_id(p.post_id))
  #     end
  #     return posts
  #   end
  
  def find_friends_posts_by_userid(user_id)
    friendships = self.find_friendships_by_userid(user_id)
    
    posts = Array.new
    friendships.each do |friendship|
      posts = self.find_posts_by_userid(friendship.friend)
    end
    
    return posts
  end
  
  ## lists all posts
  def find_all_posts_by_userid(user_id)
    user_posts = self.find_posts_by_userid(user_id)
    friends_posts = self.find_friends_posts_by_userid(user_id) 
    
    all_posts = user_posts + friends_posts
    
    return all_posts.sort! { |a, b|  b.date <=> a.date }
  end
  
  def find_post_by_commentid(comment_id)
    postcomment = PostComment.find(:first, :conditions => ["comment_id = ?", comment_id])
    return find_post_by_id(postcomment.post_id)
  end
  
  #####
  
  
  def save_userblock(userblock)
    userblock.save
    CACHE.delete("Userblocks:" + userblock.user_id.to_s)
  end
  
  def delete_userblock(userblock)
    userblocks = self.find_userblocks_by_userid(userblock.user_id)
    UserBlock.delete_all("user_id = " + userblock.user_id.to_s + " AND blocked_id = " + userblock.blocked_id.to_s)
    CACHE.delete("Userblocks:" + userblock.user_id.to_s)
  end
  
  def find_userblocks_by_userid(user_id)
    key = "Userblocks:" + user_id.to_s
    return self.check_object(CACHE[key], key) {UserBlock.find(:all, :conditions => ["user_id = ?", user_id])}
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
  
  # Delivers same objects as find_threads_by_userid, but ordered by 
  # the creation date of any contained entries
  def find_threads_by_userid_orderby_newest_entries(user_id)
    threads = self.find_threads_by_userid user_id
    for thread in threads do
      newest_entry = self.find_newest_entry_for_thread thread.id
      thread.date_of_newest_entry = newest_entry.date
    end
    threads.sort! { |b, a|  a.date_of_newest_entry <=> b.date_of_newest_entry }
  end
  
  def find_users_by_threadid(thread_id)
    key = "UserThreads:Thread:" + thread_id.to_s
    tmp_userthreads = self.check_object(CACHE[key], key) {UserThread.find(:all, :conditions => ["private_thread_id = ?", thread_id])}
    tmp_users = Array.new
    tmp_userthreads.each do |ut|
      #user_key = "User:" + ut.user_id.to_s
      tmp_user = self.find_user_by_id(ut.user_id)
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
  
  def save_user_thread(user_thread)
    return self.save_object(user_thread) {"UserThread:" + entry.id.to_s}
  end
  
  def save_thread_entry(thread_entry)
    return self.save_object(thread_entry) {"ThreadEntry:" + thread_entry.id.to_s}
  end
  
  def save_private_thread(private_thread)
    return self.save_object(private_thread) {"PrivateThread:" + private_thread.id.to_s}
  end
  
  def find_newest_entry_for_thread(thread_id)
    thread_entries = self.find_thread_entries_by_threadid thread_id
    thread_entries.sort! { |a, b|  a.date <=> b.date }
    newest_thread_entry = thread_entries.last
    return self.find_entry newest_thread_entry.entry_id
  end
  
  # Saves a NEW entry and a NEW thread_entry to an EXISTING thread
  # entry.content has to be set already
  def add_new_entry_to_thread(entry, thread_entry, private_thread, adding_user)
    entry.user_id = adding_user.id
    entry.date = Time.now
    saved_entry = self.save_entry(entry)
    thread_entry.entry_id = saved_entry.id
    thread_entry.thread_id = private_thread.id
    thread_entry.date = Time.now
    saved_thread_entry = self.save_thread_entry(thread_entry)
    
    thread_mem_key = "ThreadEntry:PrivateThread:" + private_thread.id.to_s
    CACHE.delete(thread_mem_key)
  end
  
  #Saves a NEW entry and a NEW thread_entry to a NEW thread
  #thread.title, entry.content have to be set already
  def save_new_thread(entry, thread_entry, private_thread, adding_user, receiving_users_ids)
    private_thread.date = Time.now
    private_thread.author_user_id = adding_user
    saved_thread = save_private_thread private_thread
    receiving_users_ids.push adding_user.id
    for receiving_user_id in receiving_users_ids do
      user_thread = UserThread.new 
      user_thread.private_thread_id = saved_thread.id
      user_thread.user_id = receiving_user_id
      user_thread.save
      user_thread_mem_key = "UserThreads:User:" + receiving_user_id.to_s
      CACHE.delete(user_thread_mem_key)
    end
    self.add_new_entry_to_thread entry, thread_entry, private_thread, adding_user
  end
  
  def search_posts_by_content(content, user_ids)
    results = Array.new
    for user_id in user_ids
      userposts = find_userposts_by_userid user_id.to_s
      for userpost in userposts
        post = self.find_post_by_id userpost.post_id.to_s
        hit = post.content.include? content
        if hit == true
          results.push post
        end
      end
    end
    return results
  end
  
  def search_comments_by_content(content, user_ids,logger)
    results = []
    for user_id in user_ids
      logger.debug "Retrieving coments for user " + user_id.to_s
      comments = find_comments_by_user_id user_id.to_s
      for comment in comments
        logger.debug "Comment found: " + comment.content + ", from user " + comment.user_id.to_s
        hit = comment.content.include? content
        logger.debug "which is hit: " + hit.to_s
        if hit == true
          comment_tuple = []
          comment_tuple.push comment
          parentpost = find_post_by_commentid comment.id
          comment_tuple.push parentpost
          results.push comment_tuple
          
          logger.debug "should be comment: " + comment_tuple[0].to_s
          logger.debug "should be post: " + comment_tuple[1].to_s
          
        end 
      end
    end
    return results
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
      return object
    else
      return object
    end
  end
  
end