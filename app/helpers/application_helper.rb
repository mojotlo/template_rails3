module ApplicationHelper
  def logo
    @logo=image_tag("logo.png", :alt =>"template app", :class => "round")
  end
  def profile_pic(size, css_class=nil)
    if @user.profile
      @profile_pic=image_tag(@profile.avatar.url(size), :class=>css_class)
    else
      @profile_pic=image_tag("missing_"+size.to_s+".png", :class => css_class)
    end
  end
  def 
  def about_default
    @about_default="No information given"
  end
  def conditional_link(display, condition, path)
    if current_user
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
