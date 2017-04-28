require "test_helper"

describe ProductsController do
  it "should get index" do
    #passes
    get root_path
    must_respond_with :success
  end

  it "should get the index if merchant_id is passed as params" do
    #passes
    get merchant_products_path(merchants(:dan).id)
    must_respond_with :success
  end

  it "should show an individual product" do
    #passes
    get product_path(products(:apple).id)
    must_respond_with :success
  end

  it "should get an edit page" do
    #passes
    #need to login user so that it doesn't throw an error
    login_user(merchants(:dan))
    get edit_merchant_product_path(products(:apple).merchant.id, products(:apple).id)
    must_respond_with :success
  end

  it "update should update a product or render edit" do
    #passes
    login_user(merchants(:dan))
    patch product_path(products(:banana).id), params: {product: { quantity: 2 } }
    puts "#{flash[:success]}"
    puts "#{flash.now[:error]}"
    must_respond_with :found
    must_respond_with :redirect
    must_redirect_to merchant_products_path(merchants(:dan).id, products(:banana).id )
  end


  it "should get the new page" do
    #passes
    login_user(merchants(:dan))
    get new_merchant_product_path(merchants(:dan).id)
    must_respond_with :success
  end

  it "should create a new product" do
    #passes
    proc   {
      login_user(merchants(:dan))
      post merchant_products_path(merchants(:dan).id), params: { product:
        { name: "new product",
          price: 5.00,
          quantity: 2
     }  }
   }.must_change 'Product.count', 1

   must_respond_with :redirect
   must_redirect_to merchant_products_path(merchants(:dan).id)
  end

  it "should not create an invalid product" do
    #passes
    proc   {
      post merchant_products_path(merchants(:dan).id), params: { product:
        { name: "new product",
          price: 5.00,
          quantity: 0
     }  }
   }.must_change 'Product.count', 0
  end

end
