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

      it 'allows a user to create a new hunt -- nested form for items' do
        visit root_path
        click_link("Add New Hunt")
        expect(current_path).to eq('/hunts/new')

        fill_in("hunt[name]", :with => "Canal Park")
        #will probably need to change start and finish time formats once form is created
        fill_in("hunt[start_time]", :with => "12/23/2017, 7pm")
        fill_in("hunt[finish_time]", :with => "12/23/2017, 10pm")
        fill_in("location[city]", :with => "Princeton")
        fill_in("location[state]", :with => "NJ")
        fill_in("hunt[items_attributes][0][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][1][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][2][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][3][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][4][name]", :with => Faker::Zelda.item)
        click_button('Create Hunt')
        hunt = Hunt.last

        expect(current_path).to eq(hunt_path(hunt))
        expect(page).to have_content("Canal Park")
      end

      it 'displays errors if the hunt was not saved' do
        visit new_hunt_path

        fill_in("hunt[name]", :with => "Nassau Street")
        #will probably need to change start and finish time formats once form is created
        fill_in("hunt[start_time]", :with => "12/23/2017, 7pm")
        fill_in("hunt[finish_time]", :with => "12/23/2017, 10pm")
        fill_in("hunt[items_attributes][0][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][1][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][2][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][3][name]", :with => Faker::Zelda.item)
        fill_in("hunt[items_attributes][4][name]", :with => Faker::Zelda.item)
        click_button('Create Hunt')

        expect(current_path).to eq(new_hunt_path)
        expect(page).to have_content("Location can't be blank")
      end

      #it 'has drop down selections for existing Locations' do
      #  visit new_hunt_path
      #  location = Location.find_by(city: "Princeton")

      #  fill_in("hunt[name]", :with => "Spooky Graveyard")
        #will probably need to change start and finish time formats once form is created
      #  fill_in("hunt[start_time]", :with => "12/23/2017, 7pm")
      #  fill_in("hunt[finish_time]", :with => "12/23/2017, 10pm")
      #  select(location.city_state, from: "location").select_option
      #  fill_in("hunt[items_attributes][0][name]", :with => Faker::Zelda.item)
      #  fill_in("hunt[items_attributes][1][name]", :with => Faker::Zelda.item)
      #  fill_in("hunt[items_attributes][2][name]", :with => Faker::Zelda.item)
      #  fill_in("hunt[items_attributes][3][name]", :with => Faker::Zelda.item)
      #  fill_in("hunt[items_attributes][4][name]", :with => Faker::Zelda.item)
      #  click_button('Create Hunt')
      #  hunt = Hunt.last

      #  expect(current_path).to eq(hunt_path(hunt))
      #  expect(page).to have_content("Spooky Graveyard")
      #end
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
