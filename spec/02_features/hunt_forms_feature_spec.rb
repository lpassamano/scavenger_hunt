describe 'Feature Test: Hunts Forms', :type => :feature do
  describe 'add new hunt form' do
    context 'not logged in' do
      it 'redirects to the home page' do
        visit new_hunt_path
        expect(page.current_path).to eq(root_path)
      end
    end

    context 'logged in' do
      before(:each) do
        @user = User.find(1)
        login_as(@user, scope: :user)
      end

      it 'allows a user to create a new hunt -- nested forms for items and location' do
        visit root_path
        click_link("Add New Hunt")
        expect(current_path).to eq('/hunts/new')

        fill_in("hunt[name]", :with => "Canal Park")
        #will probably need to change start and finish time formats once form is created
        fill_in("hunt[start_time]", :with => "2018-12-23T19:00")
        fill_in("hunt[finish_time]", :with => "2018-12-23T21:00")
        fill_in("hunt[location_attributes][city]", :with => "Princeton")
        fill_in("hunt[location_attributes][state]", :with => "NJ")
        page.all(:fillable_field, "hunt[items_attributes][][name]").first.set("item 1")
        page.all(:fillable_field, "hunt[items_attributes][][name]").last.set("item 2")
        click_button('Create Hunt')
        hunt = Hunt.last

        expect(current_path).to eq(hunt_path(hunt))
        expect(page).to have_content("Canal Park")
      end

      it 'displays errors if the hunt was not saved' do
        visit new_hunt_path

        fill_in("hunt[name]", :with => "Nassau Street")
        page.all(:fillable_field, "hunt[items_attributes][][name]").first.set("item 1")
        page.all(:fillable_field, "hunt[items_attributes][][name]").last.set("item 2")
        click_button('Create Hunt')

        expect(current_path).to eq(hunts_path)
        expect(page).to have_content("Location can't be blank")
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
