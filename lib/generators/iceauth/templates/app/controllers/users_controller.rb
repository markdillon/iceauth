class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :new_user?, :only => [:new, :create]
  before_filter :current_user?, :only => [:edit, :update]

  def new
    @user = User.new  
    @title = "Sign Up"
  end  

  def create  
    @user = User.new(params[:user])  
    if @user.save
      signin(@user)
      redirect_to root_url, :flash => {:success => "Signed Up!"  }
    else
      @title = "Sign Up"
      render "new"  
    end  
  end
  
  def edit
    @title = "Profile Settings"
  end
  
  def update
    if @user.authenticate(params[:user].delete(:current_password))
      if @user.update_attributes(params[:user])
        redirect_to edit_user_path(@user), :flash => {:success => "Settings Updated!"}
      else
        @title = "Profile Settings"
        render 'edit'
      end
    else
      @title = "Profile Settings"
      flash[:error] = "Please provide correct current password to update profile settings"
      render 'edit'
    end
  end
  
  private
    
    def new_user?
      redirect_to(root_path) if signed_in?
    end
    
    def current_user?
      @user = User.find(params[:id])
      redirect_to(root_path) unless @user == current_user
    end

end
