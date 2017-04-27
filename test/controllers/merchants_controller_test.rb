require "test_helper"

describe MerchantsController do

  describe "index" do
    it "succeeds with many merchants" do
      # Assumption: there are many users in the DB
      Merchant.count.must_be :>, 0

      get merchants_path
      must_respond_with :success
    end

    it "succeeds with no users" do
      Merchant.destroy_all

      get merchants_path
      must_respond_with :success
    end
  end


  describe 'show' do
    setup do
      @merchant_id = Merchant.first.id
    end

    it 'shows a merchants page' do

      get merchant_path(@merchant_id)
      must_respond_with :success
    end

    it 'returns a 404 if merchant DNE' do
      merchant2 = Merchant.last
      merchant2.destroy
      get merchant_path(merchant2.id)
      must_respond_with :not_found
    end
  end


  describe "auth_callback" do
    it "Registers a new merchant" do
      start_count = Merchant.count

      merchant = Merchant.new(
                 username: "test_user",
                 email: "test@user.new",
                 oauth_provider: "github",
                 oauth_uid: 99999
                )
      login(merchant)
      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal Merchant.last.id
      Merchant.count.must_equal start_count + 1
    end

    it "Won't registers a new user if missing data" do
      start_count = Merchant.count

      merchant = Merchant.new(
                 username: "test_user",
                 email: " ",
                 oauth_provider: "github",
                 oauth_uid: 99999
                 )
      login(merchant)
      must_respond_with :redirect
      must_redirect_to root_path
      session[:merchant_id].must_equal Merchant.last.id
      Merchant.count.must_equal start_count + 1
    end


    it "Accepts a returning user" do
      start_count = Merchant.count
      merchant = merchants(:grace)
      login(merchant)
      must_redirect_to root_path
      session[:merchant_id].must_equal merchant.id
      Merchant.count.must_equal start_count
    end

    it "Rejects incomplete auth data" do
      merchant = Merchant.new(
                email: "test@user.new",
                oauth_provider: "github",
                oauth_uid: 99999
                )
      login(merchant)
      flash[:status].must_equal :failure
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "logout" do
    it "successfully logs out logged in user" do
      merchant = merchants(:grace)
      login(merchant)
      session[:merchant_id].must_equal merchant.id

      get logout_path
      session[:merchant_id].must_be_nil
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

end
