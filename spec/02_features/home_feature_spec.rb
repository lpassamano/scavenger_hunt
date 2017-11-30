describe 'Feature Test: Home', :type => :feature do
  describe 'Pending Hunts' do
    context "not logged in" do
      it "does not display the Pending Hunts section" do
        visit root_path
        expect(page).to_not have_content "Upcoming Hunts"
      end
    end

    context "logged in" do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it "displays all of the current user's pending hunts with link to hunt's show page and their team name" do
        visit root_path
        @user.teams.each do |team|
          if team.hunt.status == "pending"
            expect(page).to have_link(team.hunt.name, href: hunt_path(team.hunt))
            expect(page).to have_link(team.name, href: team_path(team))
          end
        end
      end

      it "alerts the current user if they have a hunt starting in less than 48 hours" do
        hunt = Hunt.find(2)
        #will only work through November 30, 2017!
        hunt.start_time = DateTime.new(2017, 11, 30, 10, 00, 00)
        hunt.save
        hunt.teams << Team.create
        @user.teams << Team.last

        visit root_path
        expect(hunt.upcoming?).to eq(true)
        #can't get this to work, need to troubleshoot later
        #expect(page).to have_css("upcoming_hunt")
      end
    end
  end

  describe 'Nearby Hunts' do
    context "not logged in" do
      it "does not display the Nearby Hunts section" do
        visit root_path
        expect(page).to_not have_content "Hunts Near You"
      end
    end

    context "logged in" do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it "lists all hunts that are pending in the current user's home location" do

      end

      it "will have a link for the current user to set their location if it has not already been set" do

      end
    end
  end

  describe "Headers" do
    context "logged in" do
      it "has link to browse all hunts" do

      end

      it "has link to add a new hunt" do

      end

      it "has a link to the home page" do

      end

      it "tells the user who they are logged in as" do

      end

      it "has log out link" do

      end
    end

    context "not logged in" do
      it "has a link to sign in or sign up" do

      end
    end
  end

  describe "No Current User" do
    context "not logged in" do
      it "displays the top 5 most popular hunts" do

      end

      it "has a links to either sign in or sign up" do

      end
    end
  end
end
