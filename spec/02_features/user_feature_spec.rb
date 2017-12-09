describe 'Feature Test: User', :type => :feature do
  describe 'show profile' do
    context 'not logged in' do
      it 'redirects to the home page' do
        visit user_path(User.find(1))
        expect(page.current_path).to eq(root_path)
      end
    end

    context 'logged in' do
      before(:each) do
        @user = User.find(1)
        @user2 = User.find(2)
        @user2.location = Location.find(1)
        login_as(@user, scope: :user)
      end

      it 'lists pending hunts and teams that the user is participating in' do
        visit user_path(@user2)

        @user2.upcoming_participating_hunts.each do |hunt|
          expect(page).to have_link(hunt.name, href: hunt_path(hunt))
          expect(page).to have_link(@user2.team(hunt).name, href: hunt_team_path(hunt, @user2.team(hunt)))
        end
      end

      it 'lists the users home location and username' do
        visit user_path(@user2)
        location = "#{@user2.location.city}, #{@user2.location.state}"

        expect(page).to have_content(location)
      end

      it 'lists all hunts created by the user' do
        visit user_path(@user)

        @user.owned_hunts.each do |hunt|
          expect(page).to have_link(hunt.name, href: hunt_path(hunt))
        end
      end

      it 'if it is the current users page there is a link to edit the profile' do
        visit user_path(@user)
        expect(page).to have_link("Update Profile", edit_user_path(@user))

        login_as(@user2, scope: :user)
        visit user_path(@user)
        expect(page).to_not have_link("Update Profile", edit_user_path(@user))
      end
    end
  end

  describe 'edit profile' do
    #only can change home location and username
        # /users/id/location/edit
    #user can only edit their own profile

  end
end
