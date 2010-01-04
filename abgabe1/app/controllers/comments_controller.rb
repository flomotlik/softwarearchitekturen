class CommentsController < ApplicationController
  
  helper_method :find_userpost_by_post_id, :find_user_by_id
  
  def index
  end
  
  def show
  end
  
  def new
    @currentpost = DaoHelper.instance.find_post_by_id params[:post_id]
    @comment = Comment.new
  end

  def find_userpost_by_post_id post_id
    return DaoHelper.instance.find_userpost_by_post_id(post_id)
  end

  def find_user_by_id user_id
    return DaoHelper.instance.find_user_by_id(user_id)
  end

  def edit
    #@post = Post.find(params[:id])
  end
  
  # POST /posts
  # POST /posts.xml
  def create
    
    @currentpost = DaoHelper.instance.find_post_by_id params[:post_id]
    
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id
    @comment.date = Time.now
   
    self.save_new_comment(@comment, @currentpost)
    #DaoHelper.instance.save_comment(@comment)
   
    redirect_to( :controller => "posts", :action =>"index")
   
  end
  
  def save_new_comment comment, currentpost
    return DaoHelper.instance.save_new_comment(comment, currentpost)
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
   
  end
end
