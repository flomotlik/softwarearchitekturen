class PrivateThreadsController < ApplicationController
  
  helper_method :find_entry, :find_user_by_id, :content_of_newest_threadentry, :find_users_by_threadid, :corrected_username
  
  #List all threads
  def index
    #TODO: exchange with DAO access!
    @currentuser = current_user
    currentuserid = @currentuser.id
    @threads = DaoHelper.instance.find_threads_by_userid_orderby_newest_entries(currentuserid)
  end
  
  def show
    @currentthread = DaoHelper.instance.find_thread params[:id]
    @threadentries = DaoHelper.instance.find_thread_entries_by_threadid params[:id]
  end
  
  def find_entry (entry_id)
    return DaoHelper.instance.find_entry entry_id
  end
  
  def find_user_by_id (user_id)
    return DaoHelper.instance.find_user_by_id user_id
  end
  
  def find_users_by_threadid(thread_id)
    return DaoHelper.instance.find_users_by_threadid thread_id
  end
  
  def corrected_username(user)
    if user.id == current_user.id
      return 'You'
    else
      return user.login
    end
  end
  
  def add_entry_to_thread
    new_entry_params = params[:newentry]
    new_entry = Entry.new new_entry_params
    new_thread_entry = ThreadEntry.new
    @currentthread = DaoHelper.instance.find_thread params[:thread_id]
    DaoHelper.instance.add_new_entry_to_thread new_entry, new_thread_entry, @currentthread, current_user
    @threadentries = DaoHelper.instance.find_thread_entries_by_threadid params[:thread_id]
    @added_entry_div = 'threadentry_' + new_thread_entry.id.to_s
    respond_to do |format|
      format.html { redirect_to :action => "show", :id => params[:thread_id] }
      format.js
    end
  end
  
  def content_of_newest_threadentry(thread_id)
    newest_entry = DaoHelper.instance.find_newest_entry_for_thread thread_id
    return newest_entry.content
  end
  
  def new
    friendships = DaoHelper.instance.find_friendships_by_userid current_user.id
    @friends = Array.new
    for friendship in friendships do
      @friends.push(DaoHelper.instance.find_user_by_id friendship.friend)
    end
  end
  
  #Save a new thread (new has to be called before)
  def saveNew
    new_thread_receivers_ids = params[:receiving_users]
    new_thread = PrivateThread.new(params[:newthread])
    new_thread_entry = ThreadEntry.new
    new_entry = Entry.new(params[:newentry])
    DaoHelper.instance.save_new_thread new_entry, new_thread_entry, new_thread, current_user, new_thread_receivers_ids
    redirect_to :action => "index"
  end
  
  def submitToExisting
  
  end
  
 
  
end
