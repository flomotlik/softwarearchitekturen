class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :allposts]
  
  DAO = DaoHelper.instance
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if DAO.save_user(@user)
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
    @allposts = DAO.find_posts_by_userid(@user.id)
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    attributes = params[:user]
    if DAO.update_user(@user, attributes)
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
 