require "test_helper"

describe UsersController do
  describe "update" do
    it "updates the user" do
      patch account_path, params: { user: { username: "Bob", email: "bob@bob.com", image_url: "bob.jpg" } }
      must_redirect_to root_path
    end

    it "returns bad_request and fails to update user when given invalid data" do
      patch account_path, params: { user: { } }
      must_respond_with :bad_request
    end
  end
end
