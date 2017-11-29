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
        @user = User.find(2)
        login_as(@user, scope: :user)
      end

      it "displays all of the current user's pending hunts with link to hunt's show page and their team name" do
        visit root_path
        @user.hunts.pending.each do |hunt|
          binding.pry
          expect(page).to have_link(hunt.name, href: hunt_path(hunt), href: hunt_path(hunt))
          expect(page).to have_link(@user.team(hunt).name, href: team_path(@user.team(hunt)))
        end
      end

      it "alerts the current user if they have a hunt starting in less than 48 hours" do
        visit root_path
        #create method User#hunts.upcoming and use this for alert 
      end
    end
  end

  describe 'Nearby Hunts' do
    context "logged in" do
      it "lists all hunts that are pending in the current user's home location" do

      end

      it "will have a link for the current user to set their location if it has not already been set" do

      end
    end

    context "not logged in" do
      it "does not display the Nearby Hunts section" do

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
