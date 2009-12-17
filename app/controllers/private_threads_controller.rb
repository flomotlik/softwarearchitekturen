class PrivateThreadsController < ApplicationController
  
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
  

  
  #Create a new thread (do not save thread yet)
  def new
    
  end
  
  #Save a new thread (new has to be called before)
  def saveNew
    
   
  end
  
  def submitToExisting
  
  end
  
 
  
end
