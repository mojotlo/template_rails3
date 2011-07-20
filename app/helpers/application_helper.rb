module ApplicationHelper
  def logo
    @logo=image_tag("logo.png", :alt =>"template app", :class => "round")
  end
  def profile_pic(size)
    @profile_pic=image_tag(@profile.avatar.url(size))
  end
  def current_user_link(display, path)
    if @current_user==@user
      @current_user_link=link_to(display, path)
    else
      @current_user_link=display
    end 
  end
  def conditional_link(display, condition, path)
    if controller.signed_in? 
      if condition
        @conditional_link=link_to(display, path)
      else
        @conditional_link=display
      end
    else @conditional_link=display
    end
  end
  def current_user_is_user?
    if controller.signed_in?
      current_user==@user
    else
      return false
    end
  end

end
