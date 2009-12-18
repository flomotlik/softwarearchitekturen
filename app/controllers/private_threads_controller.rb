class PrivateThreadsController < ApplicationController
  
  helper_method :find_entry, :find_user_by_id, :content_of_newest_threadentry, :find_users_by_threadid
  
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
  
  #Create a new thread (do not save thread yet)
  def new
    
  end
  
  #Save a new thread (new has to be called before)
  def saveNew
    
   
  end
  
  def submitToExisting
  
  end
  
 
  
end
