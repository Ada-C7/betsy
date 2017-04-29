require 'test_helper'

describe UsersController do

  before do
    login(users(:grace))
  end

  describe "index" do

    it "responds with no users" do
      # skip
      User.destroy_all

      get users_path
      must_respond_with :success
    end

    # TODO must create fixtures with many users
    it "responds with multiple users" do
      # skip
      User.count.must_be :>, 0

      get users_path
      must_respond_with :success
    end
  end


  describe "new" do
    it "makes new user" do
      # skip
    end
  end


  describe "create" do
    it "adds user to database" do
      skip
      user_data = { user: { name: "Test Name", email: "test@aol.com" } }
      post users_path, params: user_data
      # T_T not necessarily where we will redirect to
      must_redirect_to users_path
    end

    it "refreshed the form if the info sucks" do
      # test if no username is given
      # skip
      user_data = { user: { email: "noname@aol.com" } }
      post users_path, params: user_data
      must_respond_with :bad_request
    end
  end


  describe "show" do
    it "responds with an existing user" do
      # skip
      get user_path(User.first)
      must_respond_with :success
    end

    it "404 with invalid user data" do
      # skip
      bad_user_id = User.last.id + 1
      get user_path(bad_user_id)
      must_respond_with :not_found
    end
  end
end
