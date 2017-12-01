module HuntHelper
  def li_for_hunt(hunt, method)
    content_tag(:li, send(method, hunt), class: ("upcoming_hunt" if hunt.upcoming?))
  end

  def with_date(hunt)
    link_to("#{hunt.name}", hunt_path(hunt)) + " | #{hunt.date}"
  end
end
