class SearchController < ApplicationController
  
  helper_method :find_userpost_by_post_id, :find_user_by_id
  
  def index
    friendships = DaoHelper.instance.find_friendships_by_userid current_user.id
    @friends = Array.new
    for friendship in friendships do
      @friends.push(DaoHelper.instance.find_user_by_id friendship.friend)
    end
  end
  
  def search
    @searchquery = params[:query][:searchquery]
    user_ids = params[:users_to_search]
    @posts = DaoHelper.instance.search_posts_by_content(@searchquery,user_ids)
  end
  
  def find_userpost_by_post_id post_id
    return DaoHelper.instance.find_userpost_by_post_id post_id
  end
  
  def find_user_by_id (user_id)
    return DaoHelper.instance.find_user_by_id user_id
  end
  
end
