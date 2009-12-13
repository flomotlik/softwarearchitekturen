# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  # method to return a value from the cache corresponding to the passed key.
  # If the value is not found, the method will do whatever you pass to it
  # and will set the output of your passed block to the key you passed in the method.
  # The object will expire in 1 hour. 
  private def cache(key)
    unless output = CACHE.get(key)
      output = yield
      CACHE.set(key, output, 1.hour)
    end
    return output
  end
  
end
