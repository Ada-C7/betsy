require "test_helper"

describe UsersController do


  # index should redirect to index
    it "can show all users by calling index" do
      get users_path
      must_respond_with :success
    end

    it "succeeds with many users" do
      # Assumption: there are many users in the DB
      User.count.must_be :>, 0

      get users_path
      must_respond_with :success
    end

    it "succeeds with no users" do
      # Start with a clean slate
      User.destroy_all

      get users_path
      must_respond_with :success
    end

    #
    # show should redirect to individual user's page
    it "show user should show one user" do
      get auth_github_callback_path, params: { uid: users(:aurora).uid, provider: users(:aurora).provider }
      get user_path(users(:aurora).id)
      must_redirect_to '/users/users(:aurora).id'
    end

    it "won't show if not your account" do
      get user_path(users(:felix).id)
      must_redirect_to :root
    end

    # This is obsolete because of the check_owner method in ApplicationController

    # it "renders 404 not_found for a bogus user" do
    #   # User.last gives the user with the highest ID
    #   # bogus_user_id = User.last.id + 1
    #   get user_path("fake_id")
    #   must_redirect_to "/public/404.html"
    # end


    describe "#edit" do
      it "should get edit form for profile" do
        get edit_user_path(users(:aurora).id)
        must_respond_with :success
      end
    end




end
