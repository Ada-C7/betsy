require "test_helper"

describe UsersController do

  describe "index" do

  end

  describe "show" do

  end

  describe "auth_callback" do
    it "logs in an existing user and redirects to the root" do
      proc {
        user = users(:one)

        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

        get auth_github_callback_path
        must_redirect_to root_path
        session[:user_id].must_equal user.id

      }.wont_change 'User.count'
    end
  end

  describe "update" do

    it "updates the user" do
      patch account_path, params: { user: { username: "Bob", email: "bob@bob.com", image_url: "bob.jpg" } }
      must_redirect_to root_path
    end

    it "returns bad_request and fails to update user when given a blank form" do
      patch account_path, params: { user: { username: "", email: "", image_url: "" } }
      must_respond_with :bad_request
    end
  end

  describe "edit" do

  end

  describe "products" do

  end

  describe "orders" do

  end

  describe "user_params" do

  end

  describe "require_login" do

  end
end
