require "test_helper"

describe UsersController do
    describe "a not logged in user" do
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
    end

    describe "a user is logged in " do
        before do
            login_user(users(:felix))
        end
        # show should redirect to individual user's page
        it "#show should show one user" do
            get user_path(users(:felix).id)
            must_respond_with :success
        end

        it "should get edit form for profile" do
            get edit_user_path(users(:felix).id)
            must_respond_with :success
        end

        it "won't show if not your account" do
            get user_path(users(:aurora).id)
            must_redirect_to :root
        end
    end

    describe "a user can update their profile" do
      before do
          login_user(users(:felix))
      end

      it "successfully updates profile" do
        get user_path(users(:felix).id)
        test_user = users(:felix)
        old_profile = test_user.profile
        patch user_path(users(:felix).id), params: {user: {id: test_user.id, username: test_user.username, email: test_user.email, uid: test_user.uid, provider: test_user.provider, profile: "My profile"}}
        changed_user = User.find_by_id(users(:felix).id)
        new_profile = changed_user.profile

        new_profile.wont_equal old_profile

      end

      it "doesn't totally break if update didn't save" do
        test_user = users(:felix)
        test_user.profile = "New"
        test_user.save
        patch user_path(test_user.id), params: { user: {profile: "", username: nil } }
        changed_user = User.find_by_id(users(:felix).id)
        new_profile = changed_user.profile
        new_profile.wont_equal ""

      end
    end
end




# This is obsolete because of the check_owner method in ApplicationController

# it "renders 404 not_found for a bogus user" do
#   # User.last gives the user with the highest ID
#   # bogus_user_id = User.last.id + 1
#   get user_path("fake_id")
#   must_redirect_to "/public/404.html"
# end
