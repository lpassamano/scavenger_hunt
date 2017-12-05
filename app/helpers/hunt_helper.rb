module HuntHelper
  def li_for_hunt(hunt, *args, method)
    content_tag(:li, send(method, hunt, *args), class: ("upcoming_hunt" if hunt.upcoming?))
  end

  def with_date(hunt)
    link_to("#{hunt.name}", hunt_path(hunt)) + " | #{hunt.date}"
  end

  def with_date_and_team(hunt, team)
    if current_user.teams.include?(team)
      user_team = link_to("#{team.name}", hunt_team_path(hunt, team))
    else
      user_team = ""
    end
    with_date(hunt) + tag(:br) + user_team
  end

  def display_upcoming_hunts_for(user)
    html = []
    user.all_upcoming_hunts.each do |hunt|
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

  def edit_and_delete_buttons(hunt)
    if current_user == hunt.owner
      case hunt.status
      when "pending"
        link_to("Edit Hunt", edit_hunt_path(hunt)) +
        button_to("Delete Hunt", hunt_path(hunt), :method => "delete", :class => "destroy")
      when "active"
        content_tag(:p, content_tag(:em, "Hunt cannot be edited or deleted while it is active."))
      when "completed"
        content_tag(:p, content_tag(:em, "Hunt cannot be edited or deleted after it is completed."))
      end
    end
  end

  def link_to_team_for_active_hunt(hunt)
    if hunt.active? && hunt.teams.include?(current_user.current_team)
      content_tag(:p, "The hunt is on!") +
      content_tag(:p, link_to("Join your team and start finding items.", hunt_team_path(hunt, current_user.current_team)))
    end
  end
end
