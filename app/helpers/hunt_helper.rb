# Helper methods for displaying hunt details in erb
module HuntHelper
  ## Methods for displaying a single hunt ##
  def li_for_hunt(with_details, hunt, *opt_details)
    # creates li for a single hunt, opt_details determines what info is shown
    content_tag(
      :li, send(with_details, hunt, *opt_details),
      class: ('upcoming_hunt' if hunt.upcoming?)
    )
  end

  def with_date(hunt)
    # opt_details for li_for_hunt
    link_to(hunt.name, hunt_path(hunt)) + " | #{hunt.date}"
  end

  def with_date_and_team(hunt, team)
    # opt_details for li_for_hunt
    user_team = link_to(team.name, hunt_team_path(hunt, team))
    with_date(hunt) + tag(:br) + user_team
  end

  def with_participants_and_date(hunt)
    # opt_details for li_for_hunt
    "#{pluralize(hunt.participants.count, 'Hunter')} | #{hunt.name} | #{hunt.date}"
  end

  ## Methods for displaying lists of hunts ##
  def display_upcoming_hunts_for(user)
    # displays all pending hunts that user is participating in
    if user.all_upcoming_hunts == []
      content_tag(:p, link_to("You don't have any upcoming scavenger hunts! Why
        don't you join one today?", hunts_path))
    else
      html = capture do
        user.all_upcoming_hunts.each do |hunt|
          concat li_for_hunt(:with_date_and_team, hunt, user.team(hunt))
        end
      end
      content_tag(:ul, html, class: 'hunt_list')
    end
  end

  def display_nearby_hunts(hunts)
    # displays all pending hunts in a location
    if hunts.nil?
      link_to('Add Your Location', edit_user_profile_path(current_user))
    elsif hunts == []
      content_tag(:p, link_to("There aren't any upcoming scavenger hunts in your
        area! Why don't you create one today?", new_hunt_path))
    else
      display_hunts(hunts)
    end
  end

  def display_top_five_hunts(hunts)
    # displays the five hunts with the most participants
    html = capture do
      hunts.each do |hunt|
        concat li_for_hunt(:with_participants_and_date, hunt)
      end
    end
    content_tag(:ul, html, class: 'hunt_list')
  end

  def display_hunts(hunts)
    # displays all hunts passed as argument
    if !!hunts && hunts != []
      html = capture do
        hunts.each do |hunt|
          concat li_for_hunt(:with_date, hunt)
        end
      end
      content_tag(:ul, html, class: 'hunt_list')
    elsif current_user
      content_tag(:p, link_to("We couldn't find any hunts! Why don't you create
        one today?", new_hunt_path))
    end
  end

  ## Methods for users ##
  def edit_and_delete_buttons(hunt)
    # allows hunt owner to edit or delete pending hunt
    # gives error messages if hunt is active or completed
    return nil unless current_user == hunt.owner
    case hunt.status
    when 'pending'
      link_to('Edit Hunt', edit_hunt_path(hunt)) +
        button_to('Delete Hunt', hunt_path(hunt), method: 'delete', class: 'destroy')
    when 'active'
      content_tag(:p, content_tag(:em, 'Hunt cannot be edited or deleted while
        it is active.'))
    when 'completed'
      content_tag(:p, content_tag(:em, 'Hunt cannot be edited or deleted after
        it is completed.'))
    end
  end

  def link_to_team_for_active_hunt(hunt)
    # if user is on a team for an active hunt, a link to their teams show page
    # will appear on root page and hunt show page
    current_user.update_current_team
    return nil unless !hunt.nil? &&
                      hunt.status == 'active' &&
                      hunt.teams.include?(current_user.current_team)
    html = capture do
      concat 'The hunt is on!'
      concat tag(:br)
      concat link_to(
        'Join your team and start finding items.',
        hunt_team_path(hunt, current_user.current_team)
      )
    end
    content_tag(:h4, html, id: 'active_hunt_link')
  end
end
