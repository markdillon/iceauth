class SessionsController < ApplicationController
  
  def new
    @title = "Sign In"
  end
  
  def create    
    user = (User.where(:username => params[:session][:login]) | User.where(:email => params[:session][:login])).first
    if user && user.authenticate(params[:session][:password])
      signin(user, params[:session][:remember_me])
      redirect_to root_url, :flash => {:success => "Logged in!"}
    else
      flash.now[:error] = "Invalid login/password combination."
      @title = "Sign in"
      render 'new'
    end
  end

  def destroy
    signout
    redirect_to root_url, :notice => "Logged out!"
  end

end
