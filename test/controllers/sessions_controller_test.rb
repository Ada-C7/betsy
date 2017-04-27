require "test_helper"

describe SessionsController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root" do
      proc {
        user = users(:one)
        login(user)

        must_redirect_to root_path
        session[:user_id].must_equal user.id

      }.wont_change 'User.count'
    end

    it "creates a new user and renders the account edit page" do
      proc {
        user = User.new(provider: "github", uid: 789, username: "Bob", email: "bob@bob.com", image_url: "bob.jpg")
        login(user)

        must_redirect_to edit_account_path
      }.must_change 'User.count', 1

      session[:user_id].must_equal User.last.id
    end

    it "does not create a new user if an invalid hash is received" do
      proc {
        user = User.new(provider: "github", uid: 999)
        login(user)
      }.wont_change 'User.count'

      must_redirect_to root_path
    end
  end
end
