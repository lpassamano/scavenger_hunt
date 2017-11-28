# hunt show page
  # while pending:
    ## has edit button for its user
    ## has delete button for its user
    ## has join and create team button for all users
    ## lists all items for the hunt
    ## lists teams that have signed up already and the number of members in the team
    ## team name is link to team show page

  # while active:
    ## has leaderboard listing teams by number of items found in descending order
    ## link to team show page on the team name

  # when completed:
    ## shows final tally of all teams
    ## link to team show page on the team name

# add/edit hunt form
  # name
  # location (add nested form for new or select from list)
  # nested form for items
  # start and end time
  # can only be edited by its user 

# index
  # list all pending hunts by start date ascending w/ link to hunt show page

# index by location
  ## url /hunts/location-slug
  # list all pending hunts in that location as in the index page
