require "test_helper"
require "pry"
#
describe MerchantsController do
  let(:merchant) {merchants(:erica)}

  describe "pages that do not require a login" do

    describe "show" do
      it "shows a merchant that exists" do
        get merchant_path(merchant.id)
        must_respond_with :success
      end

      it "returns a 404 not found status when asked for a merchant that doesn't exist" do
        merchant_id = Merchant.last.id
        merchant_id += 1
        get merchant_path(merchant_id)
        must_respond_with :not_found
      end

      describe "index" do
        it "responds successfully" do
          Merchant.count.must_be :>, 0
          get merchants_path
          must_respond_with :success
        end

        it "still responds successfully when there are no merchants" do
          Merchant.destroy_all
          get merchants_path
          must_respond_with :success
        end
      end
    end

  end

  describe "pages that redirect without a login" do

    describe "functionality blocked for guests" do
      describe "edit" do
        it "redirects edit to index" do
          get edit_merchant_path(merchant)
          must_respond_with :redirect
          must_redirect_to root_path
        end

        it "redirects update to index" do
          patch merchant_path(merchant)
          must_respond_with :redirect
          must_redirect_to root_path
        end


        it "redirects destroy to index" do
          delete merchant_path(merchant)
          must_respond_with :redirect
          must_redirect_to root_path
        end
      end
    end
  end

  describe "login" do
    describe "auth_callback" do
      it "registers a new user" do
        start_count = Merchant.count

        merchant = Merchant.new(
        username: "test_user",
        merchant_email: "test@user.net",
        oauth_provider: "github",
        oauth_uid: "99999")
        login(merchant)
        must_redirect_to root_path
        session[:user_id].must_equal Merchant.last.id, "User was not logged in"

        Merchant.count.must_equal start_count + 1

      end
    end

    it "accepts a returning user" do
      start_count = Merchant.count
      login(merchant)

      must_redirect_to root_path

      session[:user_id].must_equal merchant.id

      Merchant.count.must_equal start_count
    end
  end

  describe "pages only the store owner can access work" do
    before do
      login(merchant)
    end

    describe "edit" do
      it "should get generate form" do
        get edit_merchant_path(merchant)
        must_respond_with :success
      end

      it "should get 404 for merchant that DNE" do
        merchant_id = Merchant.last.id
        merchant_id += 1
        get edit_merchant_path(merchant_id)
        must_respond_with :not_found
      end
    end

    describe "update" do

      it "should change the merchant details" do
        merchant_data = {merchant:{
          merchant_name: "UPDATED_NAME",
          merchant_email: "email@test.com"}
        }
        patch merchant_path(merchant.id), params: merchant_data

        merchant2 = Merchant.find(merchant.id)

        merchant_data[:merchant][:merchant_email].must_equal merchant2.merchant_email

        merchant_data[:merchant][:merchant_name].must_equal merchant2.merchant_name

        must_respond_with :redirect
        must_redirect_to merchant_path(merchant.id)
      end

      it "responds with bad_request for bogus data" do
        merchant_data = {
          merchant: {
            merchant_email: ""
          }
        }
        patch merchant_path(merchant.id), params: merchant_data
        must_respond_with :bad_request
      end
    end


    describe "delete/destroy" do
      it "should remove a row from the database" do
        proc {
          delete merchant_path(merchant.id)
        }.must_change 'Merchant.count', -1

        must_respond_with :redirect
        must_redirect_to merchants_path
      end
    end
  end
end
