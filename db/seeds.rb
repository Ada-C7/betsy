require 'csv'

users = CSV.read(
  "db/support/users.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

users.each do |user|
  new_user = User.create!(user)
  if !new_user.id
    puts "Could not create user #{user.name}"
  end
end

products = CSV.read(
  "db/support/products.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

products.each do |product|
  new_product = Product.create!(product)
  if !new_product.id
    puts "Could not create product #{product.name}"
  end
end

orders = CSV.read(
  "db/support/orders.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

orders.each do |order|
  new_order = Order.create!(order)
  if !new_order.id
    puts "Could not create order #{order.name}"
  end
end
