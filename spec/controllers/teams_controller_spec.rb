require 'rails_helper'

describe TeamsController, type: :controller do
  let(:user) { create :user }
  let(:team_member) { create :user }
  let(:team) { create :team }
  let(:hunt) { create :hunt }
  let(:valid_params) do
    {name: "team 1"}
  end

  let(:valid_params_add_member) do
    {participant_id: team_member.id}
  end

  let(:valid_params_remove_member) do
    {remove_participant_id: team_member.id}
  end

  # let :invalid_params do
  #   valid_params.deep_merge({ name: "" })
  # end

  context "unauthenticated user" do
    it "can't view team page" do
      get :show, params: { id: team.id, hunt_id: team.hunt_id }
      expect(response.status).to eq(302)
    end

    it "can't create team" do
      get :new, params: { hunt_id: hunt.id }
      expect(response.status).to eq(302)
      expect{
        post :create, params: { hunt_id: hunt.id, team: valid_params }
      }.to_not change(Team, :count)
      expect(response.status).to eq(302)
    end

    it "can't update team" do
      expect{
        post :update, params: { hunt_id: team.hunt_id, id: team.id, team: valid_params_add_member }
      }.to_not change(team.participants, :count)
      expect(response.status).to eq(302)
    end
  end

  context "authenticated user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(user, scope: :user)
    end

    it "can view team page" do
      get :show, params: { id: team.id, hunt_id: team.hunt_id }
      expect(response.status).to eq(200)
    end

    it "can create team" do
      get :new, params: { hunt_id: hunt.id }
      expect(response.status).to eq(200)
      expect{
        post :create, params: { hunt_id: hunt.id, team: valid_params }
      }.to change(Team, :count).by(1)
      expect(response.status).to eq(302)
    end

    context "is not a team member" do
      it "can't update team" do
        # add member
        expect{
          post :update, params: { hunt_id: team.hunt_id, id: team.id, team: valid_params_add_member }
        }.to_not change(team.participants, :count)
        expect(response.status).to eq(302)

        # remove member
        expect{
          post :update, params: { hunt_id: team.hunt_id, id: team.id, team: valid_params_remove_member }
        }.to_not change(team.participants, :count)
        expect(response.status).to eq(302)
      end
    end

    context "is a team member" do
      it "can update team" do
        team.participants << user
        # add member
        expect{
          post :update, params: { hunt_id: team.hunt_id, id: team.id, team: valid_params_add_member }
        }.to change(team.participants, :count).by(1)
        expect(response.status).to eq(302)

        # remove member
        expect{
          post :update, params: { hunt_id: team.hunt_id, id: team.id, team: valid_params_remove_member }
        }.to change(team.participants, :count).by(-1)
        expect(response.status).to eq(302)
      end
    end
  end
end
