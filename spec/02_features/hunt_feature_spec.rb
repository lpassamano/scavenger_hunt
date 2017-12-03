describe 'Feature Test: Hunts', :type => :feature do
  describe 'index page' do
    context 'not logged in' do
      it 'redirects to the home page' do
        visit hunts_path
        expect(page.current_path).to eq(root_path)
      end
    end

    context 'logged in' do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it 'lists all pending hunts by start date in ascending order' do
        visit hunts_path
        hunts = Hunt.all_pending.sort {|x, y| x.start_time <=> y.start_time}
        expect(hunts == Hunt.all_pending).to eq(true)
      end

      it 'has a link to each hunts show page' do
        visit hunts_path
        Hunt.all_pending.each do |hunt|
          expect(page).to have_link(hunt.name, href: hunt_path(hunt))
        end
      end

      it 'has the ability to filter by location' do
        location = Location.find_by(city: "New York")
        visit hunts_path
        select(location.city_state, from: "location").select_option
        click_button("Filter")

        Hunt.all_pending.each do |hunt|
          if hunt.location == location
            expect(page).to have_link(hunt.name, href: hunt_path(hunt))
          else
            expect(page).to_not have_link(hunt.name, href: hunt_path(hunt))
          end
        end
      end
    end
  end

  describe 'show page' do
    context 'not logged in' do
      it 'redirects to the home page' do
        hunt = Hunt.find(1)
        visit hunt_path(hunt)
        expect(page.current_path).to eq(root_path)
      end
    end

    context 'logged in as hunt owner' do
      before(:each) do
        @user = User.find(1)
        @owner_hunt = Hunt.where(owner: @user).first
        @participant_hunt = @user.upcoming_participating_hunts.find {|hunt| hunt.owner != @user}
        login_as(@user, scope: :user)
      end

      context 'pending hunt' do
        it 'has edit link only for its user' do
          visit hunt_path(@owner_hunt)
          expect(page).to have_link("Edit Hunt", edit_hunt_path(@owner_hunt))

          visit hunt_path(@participant_hunt)
          expect(page).to_not have_link("Edit Hunt", edit_hunt_path(@participant_hunt))
        end

        it 'has a delete button only for its user' do
          visit hunt_path(@owner_hunt)
          expect(page).to have_button("Delete Hunt")

          visit hunt_path(@participant_hunt)
          expect(page).to_not have_button("Delete Hunt")
        end

        it 'lists all teams participating in the hunt with number of team members and a link to join the team' do
          visit hunt_path(@participant_hunt)

          @participant_hunt.teams.each do |team|
            expect(page).to have_content(team.name)
            expect(page).to have_button("Join Team")
          end
        end

        it 'has link to create a new team' do
          visit hunt_path(@participant_hunt)
          expect(page).to have_link("Make New Team", new_team_path)
        end

        it 'lists all items with links to edit and remove item for owner only' do

        end
      end

      context 'active hunt' do
        it 'does not allow the user to edit or delete a hunt once it has started' do
          # no edit options for anything
        end

        it 'has leaderboard listing teams by number of items found in descending order' do

        end

        it 'links to team show page on the team name' do

        end
      end

      context 'completed hunt' do

      end
    end

    context 'logged in as participant' do
      before(:each) do
        #change this to different user
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      context 'pending hunt' do
        it 'has no link to edit hunt' do

        end

        it 'has no delete button' do

        end

        it 'lists all teams participating in the hunt with number of team members and link to join the team' do

        end

        it 'has a link to create a new team' do

        end

        it 'does not list the items for the hunt' do

        end
      end

      context 'active hunt' do
        it 'has leaderboard listing teams by number of items found in descending order' do

        end

        it 'links to team show page on the team name' do

        end
      end

      context 'completed hunt' do
        #this page is the same if you are the hunt owner or participant
        before(:each) do
          @user = User.find(1)
          login_as(@user, scope: :user)
        end

        it 'shows final tally of all teams' do

        end

        it 'has a link to each team show page' do

        end
      end
    end
  end

  describe 'add new hunt form' do
    context 'not logged in' do
      it 'redirects to the home page' do

      end
    end

    context 'logged in' do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it 'allows a user to create a new hunt' do
        #name, start_time, finish_time
        #redirects to show page after to check if it was added
      end

      it 'contains a nested form to add location' do

      end

      it 'contains a nested form to add items' do

      end

      it 'displays errors if the hunt was not saved' do
        # rerenders the add form
      end
    end
  end

  describe 'edit hunt form' do
    context 'not logged in' do
      it 'redirects to the home page' do

      end
    end

    context 'logged in' do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it 'can only be edited by its owner' do

      end

      it 'start and finish time cannot be changed to the past' do

      end

      it 'successfully updates a hunt' do

      end

      it 'displays error if the hunt was not saved' do

      end
    end
  end
end
