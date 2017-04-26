require "test_helper"

describe UsersController do

  describe "index" do

  end

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
  end

  describe "logged in users" do
    before do
      login(users(:one))
    end

    describe "show" do
      it "succeeds for a user that exists" do
        get account_path
        must_respond_with :success
      end

      it "redirects to the root path if a user is not logged in" do
        delete logout_path

        get account_path
        must_respond_with :bad_request
      end
    end

    describe "update" do

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
end
