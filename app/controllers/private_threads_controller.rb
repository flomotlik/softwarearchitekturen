class PrivateThreadsController < ApplicationController
  
  #List all threads
  def index
    #TODO: exchange with DAO access!
    @currentuser = current_user
    currentuserid = @currentuser.id
    @threads = DaoHelper.instance.find_threads_by_userid(currentuserid)
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
