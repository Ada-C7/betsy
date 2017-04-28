require "test_helper"

describe SessionsController do

    it "can login an existing user" do
      proc {
        login_user(users(:aurora))

        #check for redirection
        must_redirect_to root_path

        #check that session was set
        session[:user_id].must_equal (users(:aurora)).id

        #Check that a new user wasn't created
      }.must_change 'User.count', 0
    end

    it "login succeeds for a new user & creates them" do

      # Precondition: no user with this username exists
      User.find_by(username: "Jamie", uid:"999", provider:"github", email: "Jamie@adadevelopersacademy.com").must_be_nil

      jamie = User.new(username:"Jamie", uid:"999", provider:"github", email: "Jamie@adadevelopersacademy.com")

      proc {
        login_user(jamie)

        #check for redirection
        must_redirect_to root_path

        #check that session was set
        session[:user_id].must_equal User.find_by(username: "Jamie").id

        #Check that a new user was created
      }.must_change 'User.count', 1
    end

    it "if github gives us bad data, does not create user and redirects to root" do

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({})

      proc {
        get auth_github_callback_path

        must_redirect_to root_path

        session[:user_id].must_be_nil
        flash[:error].must_equal "Could not log in"

      }.must_change 'User.count', 0
    end

    it "if new user fails validations ddoes not create user and redirects to root" do
      #same as user in our yml file except for provider is different
      dupe_aurora = User.new(username:"auroralemieux", uid: "12345", provider:"gmail", email: "aurora@test.com")

      proc {
        login_user(dupe_aurora)

        #check for redirection
        must_redirect_to root_path

        session[:user_id].must_be_nil
        flash[:error].must_equal "Could not log in"
      }.must_change 'User.count', 0
    end

    it "logout succeeds if the user is logged in" do
      # Gotta be logged in first
      login_user(users(:aurora))

      delete logout_path

      session[:user_id].must_be_nil
      must_redirect_to root_path
    end
  end
