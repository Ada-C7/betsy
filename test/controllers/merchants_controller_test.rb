require "test_helper"

describe MerchantsController do

  it "should get index" do
    #passes
    get merchants_path
    must_respond_with :success
  end

  it "should show one merchant" do
    #passes
    get merchant_path(merchants(:dan))
    must_respond_with :success
  end

  it "should show 404 if merchant not found" do
    #passes
    get merchant_path(305)
    must_respond_with :missing
  end

  it "should get edit" do
    #passes
    login_user(merchants(:dan))
    get edit_merchant_path(merchants(:dan))
    must_respond_with :success
  end

  it "should update a merchant's info" do
    login_user(merchants(:dan))
    dan = merchants(:dan)
    puts "#{dan.name}"
    put merchant_path(dan.id), params: {
      merchant:
      { name: "ME" }
    }
    dan.reload
    puts "#{dan.name}"


    must_respond_with :ok
  end

  it "should redirect to merchant index after creating merchant" do
    #this test is run through sessions and the create action is tested in the sessions controller test (creating a user when you login to Github)
    #passes
    post merchants_path params: {merchant:
      { username: "peeves",
        email: "peeves@hogwarts.com",
        uid: 49,
        provider: "cool"
      }
    }
    must_respond_with :found
  end

  it "should flash an error page if new merchant info is not valid" do
    post merchants_path params: {merchant:
      { username: nil,
        email: "peeves@hogwarts.com",
        uid: 49,
        provider: "cool"
      }
    }

    flash[:error].must_equal "Merchant not created. Ghosts must be mad."
  end

  it "should affect the model when adding a merchant" do
    proc {
      post merchants_path params: {merchant:
        { username: "peeves",
          email: "peeves@hogwarts.com",
          description: "Products for obnoxious yet discerning ghosts",
          uid: 12,
          provider: "lala"
        }
      }
    }.must_change 'Merchant.count', 1
  end

  it "should not affect the model when trying to add an invalid merchant" do
    proc {
      post merchants_path params: {merchant:
        {
          email: "peeves@hogwarts.com",
          description: "Products for obnoxious yet discerning ghosts"
        }
      }
    }.must_change 'Merchant.count', 0
  end




end
