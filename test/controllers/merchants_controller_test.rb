require "test_helper"

describe MerchantsController do

  describe "index" do
    it "gets index" do
      get merchants_path
      must_respond_with :success
    end

    it "still responds when there are no merchants" do
      Merchant.destroy_all
      get merchants_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "displays a book that exists" do
      merchant = merchants(:one)
      get merchant_path(merchant.id)
      must_respond_with :success
    end
    it "will return 404 if merchant does not exist" do
      merchant_id = Merchant.last.id + 1
      get edit_merchant_path(merchant_id)
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "checks to make sure being redirected to new_merchants_path" do
      get new_merchant_path
      must_respond_with :success
    end

  end

  describe "create" do
    it "adds merchant to database" do
      merchant = { merchant: { name:"Merchant", username:"merchant1", email:"merchantsarecool@gmail.com" } }
      post merchants_path, params: merchant
      must_redirect_to merchants_path
    end

    it "re-renders merchants form if merchant invalid" do
      merchant = { merchant: { name: "Mark Merchant" } }
      post merchants_path, params: merchant
      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "finds a merchant who exists" do
      merchant = merchants(:one)
      get edit_merchant_path(merchant.id)
      must_respond_with :success
    end

    it "returns 404 for a merchant who DNE" do
      merchant_id = Merchant.last.id + 1
      get edit_merchant_path(merchant_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "updates an existing merchant" do
      merchant = merchants(:one)
      patch merchant_path(merchant), params: { merchant: { email: "updated@gmail.com" } }
    end

    it "updates the merchant" do
      merchant = merchants(:one)
      merchant_data = {
        merchant: {
          name: merchant.name + " extra stuff"
        }
      }

      patch merchant_path(merchant), params: merchant_data
      must_redirect_to merchant_path(merchant)
      merchant.reload

      merchant.name.must_equal merchant_data[:merchant][:name]
    end

    it "responds with bad_request for weird data" do
      merchant = merchants(:one)
      merchant_data = {
        merchant: {
          username: ""
        }
      }

      patch merchant_path(merchant), params: merchant_data
      must_respond_with :bad_request

      merchant.username.must_equal merchant.username
    end

    it "returns 404 for a merchant who does not exist" do
      merchant_data = {
        merchant: {
          name: "test name"
        }
      }

      merchant_id = Merchant.last.id + 1
      patch merchant_path(merchant_id), params: merchant_data
      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "destroys a merchant who exists" do
      start_count = Merchant.count

      merchant = merchants(:one)
      delete merchant_path(merchant)
      must_redirect_to merchants_path

      end_count = Merchant.count
      end_count.must_equal start_count - 1
    end

    it "returns 404 for a classroom that DNE" do
      start_count = Merchant.count

      merchant_id = Merchant.last.id + 1
      delete merchant_path(merchant_id)
      must_respond_with :not_found

      end_count = Merchant.count
      end_count.must_equal start_count
    end
  end


end
