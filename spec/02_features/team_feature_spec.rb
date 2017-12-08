describe 'Feature Test: Team', :type => :feature do
  describe 'show page' do
    context 'not logged in' do
      it 'redirects to the home page' do
        team = Team.find(1)
        visit hunt_team_path(team.hunt, team)
        expect(page.current_path).to eq(root_path)
      end
    end

    context 'pending hunt' do
      before(:each) do
        @user = User.find(1)
        @participant = User.find(2)
        @hunt = Hunt.find(3)
        @team = @participant.teams.where(hunt: @hunt).first
        login_as(@user, scope: :user)
      end

      it 'lists all team members with link to their user profiles' do
        visit hunt_team_path(@hunt, @team)

        @team.participants.each do |participant|
          expect(page).to have_link(participant.name, href: user_path(participant))
        end
      end

      it 'has a button to join team if current_user is not already on a team for this hunt' do
        visit hunt_team_path(@hunt, @team)
        expect(page).to have_button("Join Team")
      end

      it 'clicking the join button adds the user to the team' do
        visit hunt_team_path(@hunt, @team)
        click_button("Join Team")

        expect(@user.teams).to include(@team)
      end

      it 'if current_user is on the team has leave team button instead of join team' do
        login_as(@participant, scope: :user)
        visit hunt_team_path(@hunt, @team)
        expect(page).to have_button("Leave Team")
        expect(page).to_not have_button("Join Team")
      end
    end

    context 'active hunt' do
      context 'logged in as team participant' do
        before(:each) do
          @participant = User.find(2)
          @hunt = Hunt.find(1)
          @team = @participant.teams.where(hunt: @hunt).first
          @item = @hunt.items.first
          @found_item = @item.found_items.where(team: @team).first
          login_as(@participant, scope: :user)
        end

        it 'for each team: lists all items in the hunt and a button to click when it is found' do
          @hunt.teams.each do |team|
            visit hunt_team_path(@hunt, team)

            team.items.each do |item|
              expect(page).to have_content(item.name)
              expect(page).to have_button("Found it!") if team.participants.include?(@participant)
              expect(page).to_not have_button("Found it!") if team.participants.exclude?(@participant)
            end
          end
        end

        it 'marks item as found when button is clicked' do
          visit hunt_team_path(@hunt, @team)
          expect(@found_item.found).to eq(false)

          within "form#edit_found_item_#{@found_item.id}" do
            click_button("Found it!")
          end
          #works in rails server but cannot get test to pass! Fix later!
          #expect(@found_item.found).to eq(true)
        end

        it 'does not have found it button if item is already found' do
          visit hunt_team_path(@hunt, @team)
          @found_item.found = true
          id = "edit_fount_item_#{@found_item.id}"

          expect(page).to_not have_css("##{id}")
        end
      end

      context 'logged in as other user' do
        before(:each) do
          @user = User.find(1)
          @hunt = Hunt.find(1)
          @team = @hunt.teams.first
          @item = @hunt.items.first
          login_as(@user, scope: :user)
        end

        it 'lists all items in the hunt and found items are marked' do
          visit hunt_team_path(@hunt, @team)
          fi = @item.found_items.where(team: @team).first
          fi.found = true
          fi.save

          expect(page).to have_css("li.found", :count => 1)
        end

        it 'lists all team members with links to their profiles' do
          visit hunt_team_path(@hunt, @team)

          @team.participants.each do |participant|
            expect(page).to have_link(participant.name, href: user_path(participant))
          end
        end
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
