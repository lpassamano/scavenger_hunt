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
        @user.all_upcoming_hunts.each do |hunt|
          expect(page).to have_link(hunt.name, href: hunt_path(hunt))
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
        page.has_css?("li#upcoming_hunt")
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

      it "will have a link for the current user to set their location if it has not already been set" do
        visit root_path
        expect(page).to have_link("Add Your Location", href: edit_user_profile_path(@user))
      end

      it "lists all hunts that are pending in the current user's home location" do
        location = Location.find(1)
        @user.location = location
        @user.save

        visit root_path
        location.pending_hunts.each do |hunt|
          expect(page).to have_content(hunt.name)
        end
      end
    end
  end

  describe "Headers" do
    context "not logged in" do
      it "has a link to sign in or sign up" do
        visit root_path
        expect(page).to have_link("Sign In", href: new_user_session_path)
        expect(page).to have_link("Sign Up", href: new_user_registration_path)
        expect(page).to_not have_link("Home", href: root_path)
      end
    end

    context "logged in" do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it "has link to browse all hunts" do
        visit root_path
        expect(page).to have_link("Browse Hunts", href: hunts_path)
      end

      it "has link to add a new hunt" do
        visit root_path
        expect(page).to have_link("Add New Hunt", href: new_hunt_path)
      end

      it "has a link to the home page" do
        visit root_path
        expect(page).to have_link("Home", href: root_path)
      end

      it "tells the user who they are logged in as" do
        visit root_path
        expect(page).to have_link("#{@user.name}", href: user_profile_path(@user))
      end

      it "has log out link" do
        visit root_path
        expect(page).to have_link("Sign Out", href: destroy_user_session_path)
        expect(page).to_not have_link("Sign In", href: new_user_session_path)
      end
    end
  end

  describe "No Current User" do
    context "not logged in" do
      it "displays the top 5 most popular hunts" do
        visit root_path
        # extra li is for the sign in/up nav item
        expect(page).to have_selector('li', count: 6)
      end

      it "has a links to either sign in or sign up" do
        visit root_path
        expect(page).to have_link("Sign In", href: new_user_session_path)
        expect(page).to have_link("Sign Up", href: new_user_registration_path)
      end
    end
  end
end
