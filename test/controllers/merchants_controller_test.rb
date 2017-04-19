require "test_helper"

describe MerchantsController do



  describe 'show' do
    let (:merchant) { Merchant.first}

    it 'shows a merchants page' do
      get merchant_path(merchant.id)
      must_respond_with :success
    end

    it 'returns a 404 if merchant DNE' do
      merchant2 = Merchant.last
      merchant2.destroy
      get merchant_path(merchant2.id)
      must_respond_with :not_found
    end

    end
  end
end
