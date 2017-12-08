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
        hunts = Hunt.pending.sort {|x, y| x.start_time <=> y.start_time}
        expect(hunts == Hunt.pending).to eq(true)
      end

      it 'has a link to each hunts show page' do
        visit hunts_path
        Hunt.pending.each do |hunt|
          expect(page).to have_link(hunt.name, href: hunt_path(hunt))
        end
      end

      it 'has the ability to filter by location' do
        location = Location.find_by(city: "New York")
        visit hunts_path
        select(location.city_state, from: "location").select_option
        click_button("Filter")

        Hunt.pending.each do |hunt|
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

      context 'pending hunt' do
        before(:each) do
          @owner_hunt = Hunt.find(3)
          @user = @owner_hunt.owner
          login_as(@user, scope: :user)
        end

        it 'has edit link only for its user' do
          visit hunt_path(@owner_hunt)
          expect(page).to have_link("Edit Hunt", href: edit_hunt_path(@owner_hunt))
        end

        it 'has a delete button' do
          visit hunt_path(@owner_hunt)
          expect(page).to have_button("Delete Hunt")
        end

        it 'lists all teams participating in the hunt with number of team members and a link to join the team' do
          visit hunt_path(@owner_hunt)

          @owner_hunt.teams.each do |team|
            expect(page).to have_content(team.name)
            expect(page).to have_button("Join Team")
          end
        end

        it 'has link to create a new team' do
          visit hunt_path(@owner_hunt)
          expect(page).to have_link("Make New Team", href: new_hunt_team_path(@owner_hunt))
        end

        it 'lists all items with links to edit and remove item' do
          visit hunt_path(@owner_hunt)

          @owner_hunt.items.each do |item|
            expect(page).to have_content(item.name)
            expect(page).to have_link("Edit Item", href: edit_hunt_item_path(@owner_hunt, item))
            expect(page).to have_button("Remove Item")
          end
        end
      end

      context 'active hunt' do
        before(:each) do
          @active_hunt = Hunt.find(1)
          @user = @active_hunt.owner
          login_as(@user, scope: :user)
        end

        it 'does not allow the owner to edit or delete a hunt once it has started' do
          visit hunt_path(@active_hunt)
          expect(page).to have_content("Hunt cannot be edited or deleted while it is active")
        end

        it 'has leaderboard listing teams by number of items found in descending order' do
          visit hunt_path(@active_hunt)
          expect(page).to have_content("Leaderboard")

          teams = @active_hunt.teams.sort {|x, y| y.found_items.where(found: true).count <=> x.found_items.where(found: true).count}
          expect(teams == @active_hunt.leaderboard).to eq(true)

          @active_hunt.teams.each do |team|
            expect(page).to have_link(team.name, href: hunt_team_path(@active_hunt, team))
            expect(page).to have_content(team.found_items.where(found: true).count)
          end
        end

        it 'does not have edit/delete item options' do
          visit hunt_path(@active_hunt)

          @active_hunt.items.each do |item|
            expect(page).to have_content(item.name)
            expect(page).to_not have_link("Edit Item", href: edit_hunt_item_path(@active_hunt, item))
            expect(page).to_not have_button("Remove Item")
          end
        end
      end

      context 'completed hunt' do
        before(:each) do
          @user = User.find(1)
          @completed_hunt = Hunt.find(2)
          login_as(@user, scope: :user)
        end

        it 'shows final tally of all teams with link to team show pages' do
          visit hunt_path(@completed_hunt)
          expect(page).to have_content("Final Scores")

          teams = @completed_hunt.teams.sort {|x, y| y.found_items.count <=> x.found_items.count}
          expect(teams == @completed_hunt.leaderboard).to eq(true)

          @completed_hunt.teams.each do |team|
            expect(page).to have_link(team.name, href: hunt_team_path(@completed_hunt, team))
            expect(page).to have_content(team.found_items.count)
          end
        end

        it 'does not have links to edit/delete the hunt or items' do
          visit hunt_path(@completed_hunt)
          expect(page).to have_content("Hunt cannot be edited or deleted after it is completed.")

          @completed_hunt.items.each do |item|
            expect(page).to have_content(item.name)
            expect(page).to_not have_link("Edit Item", href: edit_hunt_item_path(@completed_hunt, item))
            expect(page).to_not have_button("Remove Item")
          end
        end
      end
    end

    context 'logged in as participant' do

      context 'pending hunt' do
        before(:each) do
          @user = User.find(2)
          @participant_hunt = Hunt.find(3)
          login_as(@user, scope: :user)
        end

        it 'has no link to edit hunt' do
          visit hunt_path(@participant_hunt)
          expect(page).to_not have_link("Edit Hunt", href: edit_hunt_path(@participant_hunt))
        end

        it 'has no delete button' do
          visit hunt_path(@participant_hunt)
          expect(page).to_not have_button("Delete Hunt")
        end

        it 'lists all teams participating in the hunt' do
          visit hunt_path(@participant_hunt)

          @participant_hunt.teams.each do |team|
            expect(page).to have_content(team.name)
          end
        end

        it 'has a link to create a new team' do
          visit hunt_path(@participant_hunt)
          expect(page).to have_link("Make New Team", href: new_hunt_team_path(@participant_hunt))
        end

        it 'does not list the items for the hunt' do
          visit hunt_path(@participant_hunt)
          expect(page).to_not have_content(@participant_hunt.items.first.name)
        end
      end

      context 'active hunt' do
        before(:each) do
          @active_hunt = Hunt.find(1)
          @participant = User.find(2)
          login_as(@participant, scope: :user)
          @team = @participant.teams.where(hunt: @active_hunt)
        end

        it 'has leaderboard listing teams by number of items found in descending order' do
          visit hunt_path(@active_hunt)
          expect(page).to have_content("Leaderboard")

          teams = @active_hunt.teams.sort {|x, y| y.found_items.count <=> x.found_items.count}
          expect(teams == @active_hunt.leaderboard).to eq(true)

          @active_hunt.teams.each do |team|
            expect(page).to have_link(team.name, href: hunt_team_path(@active_hunt, team))
            expect(page).to have_content(team.found_items.count)
          end
        end

        it 'alerts the user that the hunt is active and that they can participate via team show page' do
          visit hunt_path(@active_hunt)
          expect(page).to have_link("Join your team and start finding items.", href: hunt_team_path(@active_hunt, @participant.current_team))
        end
      end

      context 'completed hunt' do
        before(:each) do
          @participant = User.find(2)
          @completed_hunt = Hunt.find(2)
          login_as(@participant, scope: :user)
        end

        it 'shows final tally of all teams with link to team show pages' do
          visit hunt_path(@completed_hunt)
          expect(page).to have_content("Final Scores")

          teams = @completed_hunt.teams.sort {|x, y| y.found_items.count <=> x.found_items.count}
          expect(teams == @completed_hunt.leaderboard).to eq(true)

          @completed_hunt.teams.each do |team|
            expect(page).to have_link(team.name, href: hunt_team_path(@completed_hunt, team))
            expect(page).to have_content(team.found_items.count)
          end
        end

        it 'has no alert for the user' do
          visit hunt_path(@completed_hunt)
          expect(page).to_not have_link("Join your team and start finding items.", href: hunt_team_path(@completed_hunt, @participant.current_team))
        end
      end
    end
  end
end
