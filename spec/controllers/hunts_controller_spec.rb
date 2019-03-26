require 'rails_helper'

describe HuntsController, type: :controller do
  let :user { create :user }

  let :valid_params { attributes_for :hunt_params }

  let :invalid_params do
    valid_params.deep_merge({ name: "" })
  end

  context '- Unathenticated User' do
    it "can't view list of hunts" do
      get :index
      expect(response.status).to eq(302)
    end

    it "can't view a hunt" do
      hunt = create :hunt
      get :show, params: { id: hunt.id }
      expect(response.status).to eq(302)
    end

    it "can't create a hunt" do
      get :new
      expect(response.status).to eq(302)
      expect{
        post :create, params: valid_params
      }.to_not change(Hunt, :count)
      expect(response.status).to eq(302)
    end

    it "can't view edit hunt form" do
      hunt = create :hunt
      get :edit, params: { id: hunt.id }
      expect(response.status).to eq(302)
    end

    it "can't update a hunt" do
      hunt = create :hunt
      post :update, params: { id: hunt.id, hunt: valid_params }
      expect(response.status).to eq(302)
      expect(hunt.name).to_not be(valid_params['name'])
    end
  end

  context '- Authenticated User' do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(user, scope: :user)
    end

    it 'can view list of hunts' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'can view a hunt' do
      hunt = create :hunt
      get :show, params: { id: hunt.id }
      expect(response.status).to eq(200)
    end

    it 'can view create new hunt form' do
      get :new
      expect(response.status).to eq(200)
    end

    it 'can create a hunt' do
      expect{
        post :create, params: { hunt: valid_params }
      }.to change(Hunt, :count).by(1)
      expect(response.status).to eq(302)
    end

    it "can't create a hunt with invalid params" do
      expect{
        post :create, params: { hunt: invalid_params }
      }.to_not change(Hunt, :count)
      expect(response.status).to eq(200)
    end

    context 'that owns a hunt' do
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in(user, scope: :user)
      end

      it 'can view edit form for their hunt' do
        hunt = create :hunt, owner: user
        get :edit, params: { id: hunt.id }
        expect(response.status).to eq(200)
      end

      it 'can update their hunt' do
        hunt = create :hunt, owner: user
        expect{
          post :update, params: { id: hunt.id, hunt: valid_params }
        }.to_not change(Hunt, :count)
        expect(response.status).to eq(302)
      end

      it "can't update their hunt with invalid params" do
        hunt = create :hunt, owner: user
        post :update, params: { id: hunt.id, hunt: invalid_params }
        expect(hunt.name).to_not be(invalid_params['name'])
        expect(response.status).to eq(200)
      end

      it 'can delete their hunt' do
        # there is a button for this but no route!
        # add in later?
      end
    end

    context 'that does not own a hunt' do
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in(user, scope: :user)
      end

      it "can't view edit form for hunt" do
        hunt = create :hunt
        get :edit, params: { id: hunt.id }
        expect(response.status).to eq(302)
      end

      it "can't update the hunt" do
        hunt = create :hunt
        post :update, params: { id: hunt.id, hunt: valid_params }
        expect(response.status).to eq(302)
        expect(hunt.name).to_not be(valid_params['name'])
      end
    end
  end
end
