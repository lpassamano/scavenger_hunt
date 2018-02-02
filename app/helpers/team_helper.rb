# Helpers for displaying team details in erb
module TeamHelper
  def display_teams_for(hunt)
    # creates list of teams for the given hunt
    html = capture do
      hunt.teams.each do |team|
        concat li_for_team(team)
      end
    end
    content_tag(:h3, header(hunt)) + content_tag(:ol, html, class: 'team_list')
  end

  def header(hunt)
    # selects header to display over team list based on hunt status
    case hunt.status
    when 'pending'
      'Teams'
    when 'active'
      'Leaderboard'
    when 'completed'
      'Final Scores'
    end
  end

  def li_for_team(team)
    # creates li element for team with details based on status
    if team.hunt.pending?
      html = join_or_leave_team_button(team.hunt, team)
    else
      html = " | #{items_found(team)} found"
    end
    content_tag(:li, link_to(team.name, hunt_team_path(team.hunt, team)) + html)
  end

  def items_found(team)
    # displays how many items found by given team
    pluralize(team.found_items.where(found: true).count, 'Item')
  end

  def link_to_make_new_team(hunt)
    # displays link to form to create new team for given hunt
    return nil unless hunt.pending? && !current_user.team(hunt)
    link_to('Make New Team', new_hunt_team_path(hunt))
  end

  def join_or_leave_team_button(hunt, team)
    # depending on if user is signed up for given team and hunt
    # displays either join team button under all teams
    # or leave team button under team they are part of
    if current_user.teams.where(hunt: hunt).count.zero?
      join_button(hunt, team)
    elsif current_user.teams.include?(team)
      leave_button(hunt, team)
    end
  end

  def join_button(hunt, team)
    # creates join button for given team and hunt
    capture do
      form_for([hunt, team]) do |f|
        concat hidden_field_tag('team[participant_id]', current_user.id)
        concat f.submit('Join Team')
      end
    end
  end

  def leave_button(hunt, team)
    # creates leave button for given team and hunt
    capture do
      form_for([hunt, team]) do |f|
        concat hidden_field_tag('team[remove_participant_id]', current_user.id)
        concat f.submit('Leave Team')
      end
    end
  end
end
