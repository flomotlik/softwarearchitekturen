class PrivateThreadsController < ApplicationController
  
  helper_method :find_entry, :find_user_by_id
  
  #List all threads
  def index
    #TODO: exchange with DAO access!
    @currentuser = current_user
    currentuserid = @currentuser.id
    @threads = DaoHelper.instance.find_threads_by_userid(currentuserid)
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
  
  def add_entry_to_thread
    new_entry_params = params[:newentry]
    new_entry = Entry.new new_entry_params
    new_thread_entry = ThreadEntry.new
    @currentthread = DaoHelper.instance.find_thread params[:thread_id]
    DaoHelper.instance.add_new_entry_to_thread new_entry, new_thread_entry, @currentthread, current_user
    redirect_to :action => "index"
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
