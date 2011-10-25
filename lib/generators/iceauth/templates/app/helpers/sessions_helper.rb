module SessionsHelper
  
  def signin(user, remember = false)
    if remember
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    else
      cookies.signed[:remember_token] = [user.id, user.salt]
    end
    @current_user = user
  end
    
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    current_user.present?
  end
  
  def signout
    cookies.delete(:remember_token)
    @current_user = nil
  end
  
  def authenticate
    redirect_to signin_path, :notice => "Please sign in to access this page." unless signed_in?
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
end
