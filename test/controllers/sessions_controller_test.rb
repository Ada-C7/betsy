require "test_helper"

describe SessionsController do
  describe "auth_callback" do
    it "New session registers a new user" do
      start_count = User.count
      user = User.new(oauth_provider: "github", oauth_uid: 99999, username: "test_name", email: "test@aol.com")

      login(user) #T_T method in test_helper

      must_redirect_to root_path
      User.count.must_equal start_count + 1
      session[:user_id].must_equal User.last.id
    end

    it "Repeat session accepts a returning user" do
      start_count = User.count

      user = users(:grace)
      login(user)

      must_redirect_to root_path

      User.count.must_equal start_count
    end

    it "Rejects incomplete auth data" do
    end
  end
end
