module TeamHelper
  def display_teams_for(hunt)
    if hunt.pending?
      header = "Teams"
      html = capture do
        hunt.teams.each do |team|
          concat li_for_team(team)
        end
      end
    else
      header = "Leaderboard" if hunt.active?
      header = "Final Scores" if hunt.completed?
      html = capture do
        hunt.leaderboard.each do |team|
          concat li_for_team(team)
        end
      end
    end
    content_tag(:h3, header) + content_tag(:ol, html, class: "team_list")
  end

  def li_for_team(team)
    if team.hunt.pending?
      html = join_or_leave_team_button(team.hunt, team)
    else
      html = " | #{pluralize(team.found_items.where(found: true).count, "Item")} found"
    end
    content_tag(:li, link_to(team.name, hunt_team_path(team.hunt, team)) + html)
  end

  def link_to_make_new_team(hunt)
    if hunt.pending? && !current_user.team(hunt)
      link_to("Make New Team", new_hunt_team_path(hunt))
    end
  end

  def join_or_leave_team_button(hunt, team)
    if current_user.teams.where(hunt: hunt).count == 0
      capture do
        form_for([hunt, team]) do |f|
          concat hidden_field_tag('team[participant_id]', current_user.id)
          concat f.submit("Join Team")
        end
      end
    elsif current_user.teams.include?(team)
      capture do
        form_for([hunt, team]) do |f|
          concat hidden_field_tag('team[remove_participant_id]', current_user.id)
          concat f.submit("Leave Team")
        end
      end
    end
  end
end
