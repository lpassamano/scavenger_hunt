module HuntHelper
  def li_for_hunt(hunt, *args, method)
    content_tag(:li, send(method, hunt, *args), class: ("upcoming_hunt" if hunt.upcoming?))
  end

  def with_date(hunt)
    link_to("#{hunt.name}", hunt_path(hunt)) + " | #{hunt.date}"
  end

  def with_date_and_team(hunt, team)
    with_date(hunt) + tag(:br) + link_to("#{team.name}", team_path(team))
  end

  def display_upcoming_hunts_for(user)
    html = []
    user.upcoming_hunts.each do |hunt|
      html << li_for_hunt(hunt, user.team(hunt), :with_date_and_team)
    end
    content_tag(:ul, html.join.html_safe)
  end

  def display_nearby_hunts(hunts)
    if hunts.nil?
      link_to("Add Your Location", edit_user_path(current_user))
    else
      display_hunts(hunts)
    end
  end

  def display_hunts(hunts)
    html = []
    hunts.each do |hunt|
      html << li_for_hunt(hunt, :with_date)
    end
    content_tag(:ul,html.join.html_safe)
  end
end
