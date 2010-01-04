class PostsController < ApplicationController
  
  helper_method :find_comment_by_id, :find_user_by_id
  
  def index
    
    @currentuser = current_user
    currentuserid = @currentuser.id
    
    @post = Post.new
    @comment = Comment.new
    
    @posts = find_all_posts_by_userid(currentuserid)
    
    #@comments = find_all_comments_by 
    
    #@posts.each do |post|
      #@posts.comments = DaoHelper.instance.find_postcomment_by_postid(post.id)
    #end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def find_all_posts_by_userid(currentuserid)
    return DaoHelper.instance.find_all_posts_by_userid(currentuserid)
  end
  
  def find_comment_by_id(post_id)
    return DaoHelper.instance.find_comment_by_id(post_id)
  end
  
  def find_user_by_id(user_id)
    return DaoHelper.instance.find_user_by_id(user_id)
  end
  
  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
  
  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    
    @user = current_user

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end
  
  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    @post.date = Time.now
    
    DaoHelper.instance.save_new_post(@post)
    
    redirect_to( :action =>"index")
    
    # respond_to do |format|
    #       flash[:notice] = 'Post was successfully created.'
    #       format.html { redirect_to("posts") }
    #     end
    
    # respond_to do |format|
    #       if @post.save      
    #           flash[:notice] = 'Post was successfully created.'
    #           format.html { redirect_to("posts") }
    #           format.xml  { render :xml => @post, :status => :created, :location => @post }
    #         else
    #           flash[:notice] = 'Post was NOT successfully created: ' + @post.errors 
    #           format.html { render :action => "new" }
    #           format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
    #         end
    #     end
  
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
end
