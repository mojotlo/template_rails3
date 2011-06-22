module SessionsHelper
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  def current_user=(user) 
    @current_user = user
  end #this function allows for assignment to the current_user variable without the use of attr_accessor
  def current_user
    @current_user ||= user_from_remember_token #use @current_user or define it
  end
  def signed_in?
    !current_user.nil?
  end
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  private
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
end
