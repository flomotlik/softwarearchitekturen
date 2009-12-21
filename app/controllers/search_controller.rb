class SearchController < ApplicationController
  
  helper_method :find_userpost_by_post_id, :find_user_by_id, :current_user, :corrected_username
  
  def index
    friendships = DaoHelper.instance.find_friendships_by_userid current_user.id
    @friends = Array.new
    for friendship in friendships do
      @friends.push(DaoHelper.instance.find_user_by_id friendship.friend)
    end
  end
  
  def search
    @error_occurred = false
    @searchquery = params[:query][:querystring]
    if !@searchquery || @searchquery == ''
      flash[:notice] = "Please enter a search string!"
      @error_occurred = true
      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.js
      end
      return
    end
    user_ids = params[:users_to_search]
    if !user_ids
      friendships = DaoHelper.instance.find_friendships_by_userid current_user.id
      user_ids = []
      for friendship in friendships
        user_ids.push friendship.friend
      end
      user_ids.push(current_user.id)
    end
    
    @posts = DaoHelper.instance.search_posts_by_content(@searchquery,user_ids)
    
    #Array of form tuples[x][0] = comment,  tuples[x][1] = post
    @comment_tuples = DaoHelper.instance.search_comments_by_content(@searchquery,user_ids,logger)
  end
  
  def find_userpost_by_post_id post_id
    return DaoHelper.instance.find_userpost_by_post_id post_id
  end
  
  def find_user_by_id (user_id)
    return DaoHelper.instance.find_user_by_id user_id
  end
  
  
  def corrected_username(user)
    if user.id == current_user.id
      return 'You'
    else
      return user.login
    end
  end
  
end
