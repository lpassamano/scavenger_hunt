describe 'Feature Test: Hunts', :type => :feature do
  describe 'index page' do
    context 'not logged in' do
      it 'redirects to the home page' do

      end
    end

    context 'logged in' do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it 'lists all pending hunts by start date in ascending order' do

      end

      it 'has a link to each hunts show page' do

      end

      it 'has the ability to filter by location' do
        ## url = /hunts/location-slug

      end
    end
  end

  describe 'show page' do
    context 'not logged in' do
      it 'redirects to the home page' do

      end
    end

    context 'logged in as hunt user' do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      context 'pending hunt' do
        it 'has edit link for its user' do

        end

        it 'has a delete button for its user' do

        end

        it 'lists all teams participating in the hunt with number of team members and a link to join the team' do

        end

        it 'has link to create a new team' do

        end

        it 'lists all items with links to edit and remove item' do

        end
      end

      context 'active hunt' do

      end

      context 'completed hunt' do

      end
    end

    context 'logged in as participant' do
      before(:each) do
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

      end

      context 'completed hunt' do

      end
    end
  end

  # hunt show page

    # while active:
      ## has leaderboard listing teams by number of items found in descending order
      ## link to team show page on the team name

    # when completed:
      ## shows final tally of all teams
      ## link to team show page on the team name




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

    end
  end
end


# add/edit hunt form
  # name
  # location (add nested form for new or select from list)
  # nested form for items
  # start and end time
  # can only be edited by its user
