require 'csv'

users = CSV.read(
  "db/support/users.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

users.each do |user|
  new_user = User.create(user)
  if !new_user.id
    puts "Could not create user #{new_user.username}"
  end
end

products = CSV.read(
  "db/support/products.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

products.each do |product|
  new_product = Product.create(product)
  if !new_product.id
    puts "Could not create product #{new_product.name}"
  end
end

orders = CSV.read(
  "db/support/orders.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

success_count = 0

orders.each do |order|
  temp_order = Order.create(order)
  if temp_order.id
    success_count += 1
    puts "#{temp_order.email} successfully added"
  end
end

puts "#{success_count} out of #{orders.length} successfully added"
