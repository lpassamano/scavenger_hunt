require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create :user }
  let(:rando) { create :user}

  let(:valid_params) do
    {
      name: 'Leigh',
      location_attributes: {
        state: "NY",
        city: "New York"
      }
    }
  end

  context "unauthenticated user" do
    it "can't view user profile" do
      expect get :show, params: { id: user.id }
      expect(response.status).to eq(302)
      response.should redirect_to(root_path)
    end

    it "can't update user profile" do
      expect get :edit, params: { id: user.id }
      expect(response.status).to eq(302)
      response.should redirect_to(root_path)
      expect{
        post :update, params: { id: user.id, user: valid_params }
      }
      expect(response.status).to eq(302)
      response.should redirect_to(root_path)

    end
  end

  context "authenticated user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(user, scope: :user)
    end

    it "can view user profile" do
      # view their profile
      expect get :show, params: { id: user.id }
      expect(response.status).to eq(200)
      response.should render_template("show")

      # view other user's profile
      expect get :show, params: { id: rando.id }
      expect(response.status).to eq(200)
      response.should render_template("show")
    end

    it "can update their user profile" do
      expect get :edit, params: { id: user.id }
      expect(response.status).to eq(200)
      response.should render_template("edit")

      # TODO: fix this controller test
      # expect{
      #   put :update, { id: user.id, user: valid_params }
      # }
      # expect(response.status).to eq(302)
      # response.should redirect_to(user_profile_path(user))
      # expect(user.name).to eq('Leigh')
    end

    it "can't update other user's profiles" do
      expect get :edit, params: { id: rando.id }
      expect(response.status).to eq(302)
      response.should redirect_to(root_path)
      expect{
        post :update, params: { id: rando.id, user: valid_params }
      }
      expect(response.status).to eq(302)
      response.should redirect_to(root_path)
      expect(rando.name).to_not eq('Leigh')
    end
  end
end
