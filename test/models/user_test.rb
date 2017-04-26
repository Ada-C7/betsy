require "test_helper"

describe User do
  it "doesn't allow a user without a username" do
    user = User.new
    user.valid?.must_equal false
    user.errors.messages.must_include :username
  end

  it "doesn't allow two users with the same username" do
    one = users(:one)
    duplicate = User.new(username: one.username, email: "sandwich@gmail.com")

    duplicate.valid?.must_equal false
  end

  it "doesn't allow a user without an email" do
    user = User.new
    user.valid?.must_equal false
    user.errors.messages.must_include :username
  end

  it "doesn't allow two users with the same email" do
    one = users(:one)
    duplicate = User.new(username: "Sandwich", email: one.email)
    duplicate.valid?.must_equal false
  end

  it "sets the username as email when the username is not given" do
    auth_hash = {
      "provider" => "github",
      "uid" => 666,
      "info" => { "email" => "bob@bob.com", "name" => "" }
    }
    user = User.create_from_github(auth_hash)

    user.username.must_equal user.email
  end
end
