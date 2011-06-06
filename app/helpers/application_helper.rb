module ApplicationHelper
  def logo
    @logo=image_tag("logo.png", :alt =>"template app", :class => "round")
  end
end
