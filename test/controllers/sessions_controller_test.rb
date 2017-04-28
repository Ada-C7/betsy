require "test_helper"

describe SessionsController do

  describe "auth_callback" do

    it "can login an existing merchant" do

      proc {
        #helper method to login a user
        login_user(merchants(:dan))
        #redirect
        must_redirect_to root_path
        #check that the session was set
        session[:merchant_id].must_equal merchants(:dan).id
        #user exists in test db so user count does not change
      }.must_change 'Merchant.count', 0
    end

    it "Can create a merchant" do
      user = Merchant.new(username: "Jamie", uid: 999, provider: 'github', email: 'jamie@adaacademy.org')

      proc {
        login_user(user)
        must_redirect_to root_path
        #check that the session was set
        session[:merchant_id].must_equal Merchant.find_by(username: 'Jamie').id
        #check that a new user was created
      }.must_change 'Merchant.count', 1

    end

    it "need valid auth_hash to login" do
      user = Merchant.new

      proc {
        login_user(user)
        must_redirect_to root_path
        #check that the session was set
        session[:merchant_id].must_equal nil
        #check that a new user was created
      }.must_change 'Merchant.count', 0

    end
  end

  describe "logging out" do
    it "can log out a logged in user" do
      #login user from fixtures
      login_user(merchants(:dan))
      post logout_path

      session[:merchant_id].must_be_nil
      must_redirect_to root_path
    end
  end



end
