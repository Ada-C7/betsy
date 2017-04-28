require "test_helper"

describe OrderProductsController do
  let(:order){Order.create(status: "pending", email: "new@gmail.com", mailing_address: "123 Main street",  card_name: "somebody fake",credit_card: "434338943", cvv: 434,zip_code: 43434, paid_at: DateTime.now, card_expiration: DateTime.now)}
  let(:merchant){Merchant.create(username: "nata", email: "ew@com")}
  let(:product){Product.create(price: 6.00, name: "bldalala", merchant: merchant, photo_url: "na/com.jpg", description: "good product", stock: 12)}
  let (:order_pr){OrderProduct.create(order_id: order.id, product_id: product.id, quantity: 2)}
  let (:category){Category.create(name: "supercategory")}

  describe "create" do
    it "adds an order_product to the database" do
      product1 = products(:owl1)
      pc1 = ProductCategory.create(product_id: product1.id, category_id: category.id)
      product1.reload
      op = OrderProduct.create(order_id: order.id, product_id: product1.id, quantity: 30)
      result = OrderProduct.find_by(order_id: order.id, product_id: product1.id)
      result.wont_be_nil
    end
    it "changing size of order products after creating" do
      before_count = OrderProduct.all.length
      product1 = products(:owl1)
      pc1 = ProductCategory.create(product_id: product1.id, category_id: category.id)
      product1.reload
      op = OrderProduct.create(order_id: order.id, product_id: product1.id, quantity: 2)
      after_count =  OrderProduct.all.length
      (after_count - before_count).must_equal 1
    end
  end #end of create block
  describe "update" do
    it "updates an order product quantity" do
      product1 = products(:owl1)
      pc1 = ProductCategory.create(product_id: product1.id, category_id: category.id)
      product1.reload
      order_product = OrderProduct.create(order_id: order.id, product_id: product1.id, quantity: 2)

      op_data = {order_product: order_product.attributes}
      op_data[:order_product][:quantity] = 11
      order_product.save
      patch order_product_path(order_product.id), params: { quantity: 11 }
      order_product.reload
      must_respond_with :redirect
      must_redirect_to shopping_cart_path
      order_product.quantity.must_equal 11
    end
  end

  describe "destroy" do
    it "successfully deletes from database" do
      order_pr = OrderProduct.create(order_id: order.id, product_id: products(:owl1).id, quantity: 2)
      delete order_product_path(order_pr.id)
      must_redirect_to shopping_cart_path
      OrderProduct.find_by(order_id: session[:order_id]).must_be_nil
    end

    it "deletes whole order if there are no order product in shopping cart" do
      order = orders(:sophia_cart)
      op1 = order_products(:order_product1)
      op2 = order_products(:order_product2)
      op3 = order_products(:order_product2)

      # delete order_product_path(op1.id)
      # delete order_product_path(op2.id)
      # delete order_product_path(op3.id)
      # order.reload
      # get order_path(order.id)
      # must_redirect_to root_path
      # result = Order.find_by(id: order.id)
      # result.must_be_nil

    end
    it "after deletion, order product doesn't exist anymore" do
      op1 = OrderProduct.first
      delete order_product_path(op1.id)
      must_redirect_to shopping_cart_path
      OrderProduct.find_by(id: op1.id).must_equal nil
    end
    it "after destroying count of order_product is changed" do
      start_count = OrderProduct.count
      op_id = OrderProduct.first.id
      delete order_product_path(op_id)
      must_redirect_to shopping_cart_path
      end_count = OrderProduct.count
      end_count.must_equal start_count - 1
    end


    end
    describe "ship" do
      it "changed the status" do
        op = OrderProduct.create(status: "paid", quantity: 2, order_id: orders(:sophia_cart).id, product_id: products(:owl1).id)
        # patch ship_order_product_path(op.id)
        # redirect_to merchant_order_view_path(op.product.merchant_id, op.order_id )
        # op.status.must_equal "shipped"
      end
  end

end
