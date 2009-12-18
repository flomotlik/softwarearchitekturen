# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'aquarium'
include Aquarium::Aspects

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  before_filter :do_aop
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end
 
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    private
      @@aop_done = false

      def do_aop
      return if @@aop_done

       Aspect.new :before, :calls_to => :all_methods, :in_types => /Controller$/,
         :method_options => :exclude_ancestor_methods do |join_point, object, *args|
         p "After: #{join_point.target_type.name}##{join_point.method_name}: object = #{object}, args = #{args}"
       end

      @@aop_done = true
      end
end
