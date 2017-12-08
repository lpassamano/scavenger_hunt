describe 'Feature Test: Team', :type => :feature do
  describe 'show page' do
    context 'not logged in' do
      it 'redirects to the home page' do
        team = Team.find(1)
        visit hunt_team_path(team)
        expect(page.current_path).to eq(root_path)
      end
    end

    context 'pending hunt' do
      # when hunt is pending:
        ## list all team members w/ link to their user pages
        ## has join team button if current_user is not already on team
        ## if already on team has button to leave team
    end

    context 'active hunt' do
      context 'logged in as team participant' do
        # when hunt is active for team participant:
          ## page is a form where they can check off items that are found
      end

      context 'logged in as other user' do
        ## list all team members w/ link to their user pages
        ## list all items in the hunt marking which ones were found
      end
    end

    context 'completed hunt' do
      ## list all team members w/ link to their user pages
      ## list all items in the hunt marking which ones were found
    end
  end

  describe 'new page' do
    # new/edit team
      # field for name
      # option to invite users - autocomplete w/ registered users usernames?
      # can be edited by any team participant
  end

  describe 'edit page' do
    # new/edit team
      # field for name
      # option to invite users - autocomplete w/ registered users usernames?
      # can be edited by any team participant
  end
end
