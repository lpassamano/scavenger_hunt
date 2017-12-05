module TeamHelper
  def display_teams_for(hunt)
    html = []
    if hunt.pending?
      header = "Teams"
      hunt.teams.each do |team|
        html << li_for_team(team)
      end
    else
      header = "Leaderboard" if hunt.active?
      header = "Final Scores" if hunt.completed?
      hunt.leaderboard.each do |team|
        html << li_for_team(team)
      end
    end
    content_tag(:h3, header) + content_tag(:ol, html.join.html_safe)
  end

  def li_for_team(team)
    if team.hunt.pending?
      text = button_to("Join Team", hunt_team_path(team.hunt, team), :method => "patch", :class => "submit")
    else
      text = " | #{team.found_items.count} items found"
    end
    content_tag(:li, link_to(team.name, hunt_team_path(team.hunt, team)) + text)
  end

  def link_to_make_new_team(hunt)
    if hunt.pending?
      link_to("Make New Team", new_hunt_team_path(hunt))
    end
  end
end
