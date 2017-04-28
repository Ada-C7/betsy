module ApplicationHelper
  def cart_is_empty?(cart)
    if cart == nil || cart.length == 0
      return true
    #else
      #     return false
    end
  end
end
