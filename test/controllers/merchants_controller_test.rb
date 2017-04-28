require "test_helper"

describe MerchantsController do
  describe "index" do
    it "succeeds with many merchants" do
      Merchant.count.must_be :>, 0

      get merchants_path
      must_respond_with :success
    end
  it "succeeds with no merchants" do
    Merchant.destroy_all

    get merchants_path
    must_respond_with :success
  end
end

  describe "show" do
    it "won't let you access a Merchant that doesn't exist" do
      bogus_user_id = Merchant.last.id + 1
      get merchant_path(bogus_user_id)
      must_redirect_to root_path
    end

    it "will let you access your own show page" do
      merchant = merchants(:grace)
      login(merchant)
      get merchant_path(merchant.id)
      must_respond_with :success
    end

    it "will show merchant's orders" do
      merchant = merchants(:grace)
      login(merchant)
      order = orders(:order234)
      get merchant_order_view_path(merchant.id, order.id)
      must_respond_with :success
    end
  end

  describe "create" do
    it "register a new user"do
      start_count = Merchant.count
      user = Merchant.new(oauth_provider: "github", oauth_id: 99999, username: "test_user", email: "test@user.com")
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)
      must_redirect_to root_path
      Merchant.count.must_equal start_count + 1
      session[:user_id].must_equal Merchant.last.id, "Merchant was not logged in"
    end

    it "accepts a returning user"do
      start_count = Merchant.count
      merchant = merchants(:grace)
      login(merchant)
      must_redirect_to root_path
      session[:user_id].must_equal merchant.id
      Merchant.count.must_equal start_count
    end

    it "rejects incomoplete oauth data" do
      start_count = Merchant.count
      user = Merchant.new(oauth_provider: "github", oauth_id: 99999)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path(:github)
      must_redirect_to root_path
      Merchant.count.must_equal start_count
      session[:user_id].must_equal nil
    end
  end
  describe "logout" do
    it "can log out a merchant" do
    merchant = merchants(:grace)
    login(merchant)
    session[:user_id].must_equal merchant.id

    delete logout_path
    session[:user_id].must_equal nil
    must_redirect_to root_path
  end
  end

end
