require "test_helper"

describe PaymentsController do
  it "gets the payment form" do
    get new_payment_path
    must_respond_with :success
  end

  it "updates the payment info in Order when someone is not logged in" do
    order = orders(:one)
    patch update_payment_path, params: { order:
      { order_id: order.id,
        email: "sai@hello.org",
        address: "123 main",
        cc_num: "45342316",
        cc_expiry: "07/19",
        cc_security: "346",
        zip: "98125"
        }
        }

    must_redirect_to payment_confirmation_path

  end

  it "updates the payment info in Order when someone is logged in" do

    #this test is not working for reasons unknowns
    login_user(merchants(:dan))
    order = orders(:one)

    patch update_payment_path, params: { order:
      { order_id: order.id,
        email: "sai@hello.org",
        address: "123 main",
        cc_num: "45342316",
        cc_expiry: "07/19",
        cc_security: "346",
        zip: "98125"
        }
        }

    must_redirect_to payment_confirmation_path

  end

  it "sends user to payment confirmation" do
    skip
  end

end
