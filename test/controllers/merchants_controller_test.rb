require "test_helper"

describe MerchantsController do
  describe "index" do
    it 'should get index' do
      Merchant.count.must_be :>, 0
      get merchants_path
      must_respond_with :success
    end
  end

  describe "new" do
    it 'should get new page' do
      get new_merchant_path
      must_respond_with :success
    end
  end

  describe "create" do
    it "Model data increases after creating merchant" do
      proc {
        post merchants_path, params:
        { merchant:
          { username: "Test",
            email: "test@test.com",
            uid: 12345,
            provider: "github"
            }
          }
        }.must_change 'Merchant.count', 1
      end

    it 'should redirect after creating merchant ' do
      skip
      post merchants_path, params: { merchant:
        { username: "Test", email: "test@test.com"
        }}
      must_respond_with :redirect
    end

    it "should show a 404 when merchant not created" do
      skip
      get item_path(7)
      must_respond_with :missing
    end
  end

  describe "show" do
    it "should get show" do
      skip
      get merchant_path(Merchant.first.id)
      must_respond_with :success
    end

    it "should get show" do
      skip
      get merchant_path(merchants(:one).id)
      must_respond_with :success
    end

    it 'should show a 404 when merchant not found' do
      skip
      get merchant_path(1)
      must_respond_with :missing
    end
  end
end
