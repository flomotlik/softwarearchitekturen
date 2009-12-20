class PostsController < ApplicationController
  
  helper_method :save_new_post, :find_userposts_by_userid
  
  #DAO = DaoHelper.instance
  
  def index
    
    @user = current_user
    @user_id = current_user.id
    @currentuser = current_user
    currentuserid = @currentuser.id
    @date = Time.now.to_i
    
    @post = Post.new
    @posts = Post.all
    @posts = DaoHelper.instance.find_userposts_by_userid(currentuserid)
    
    #@post = Post.new(params[:post])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
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
