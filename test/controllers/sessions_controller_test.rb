require "test_helper"

describe SessionsController do
  #sessions testing

  describe "auth_callback" do
    it"registers a new user" do
      start_count = Merchant.count
      merchant = Merchant.new(username:"test user", email:"test@user.net", oauth_provider: "github", oauth_uid:9999999)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)
      must_redirect_to root_path

      #This string will only show up if the test fails becasuse the merchant_id passed was not recieved
      session[:merchant_id].must_equal Merchant.last.id, "Could not log in"

      Merchant.count.must_equal start_count + 1

    end

    it "accepts a returning user" do
      start_count = Merchant.count
      merchant = merchants(:grace)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
      get auth_callback_path(:github)
      must_redirect_to root_path

      puts "Merchant ID in the local variable: #{merchant.id}"

      session[:merchant_id].must_equal merchant.id, "Merchant was not logged in"
      Merchant.count.must_equal start_count


    end
#not working anymore
    it "rejects incomplete auth data" do
      start_count = Merchant.count

      merchant = Merchant.new(username:"", email:"test@user.net", oauth_provider: "github", oauth_uid:9999999)
      login(merchant)

      must_redirect_to root_path
      flash[:message].must_equal "Could not login"

      #This string will only show up if the test fails becasuse the merchant_id passed was not recieved
      session[:merchant_id].must_equal Merchant.last.id, "Could not log in"

      Merchant.count.must_equal start_count

    end
  end
end
