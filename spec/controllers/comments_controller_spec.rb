require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:hunt) { create :hunt }

  let(:valid_params) do
    {comment: {text: "a comment", user_id: user.id}, hunt_id: hunt.id}
  end

  context "unauthenticated user" do
    it "can't create comment" do
      expect{
        post :create, params: valid_params
      }.to_not change(Comment, :count)
      expect(response.status).to eq(302)
    end
  end

  context "authenticated user" do
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in(user, scope: :user)
    end

    it "can create comment with valid params" do
      expect{
        post :create, params: valid_params
      }.to change(Comment, :count).by(1)
      expect(response.status).to eq(302)
    end
  end
end
