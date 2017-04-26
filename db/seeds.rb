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
    puts new_product.errors.messages
  end
end

orders = CSV.read(
  "db/support/orders.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

orders.each do |order|
  new_order = Order.create(order)
  if !new_order.id
    puts "Could not create order by #{new_order.email}"
  end
end

10.times do
  OrderItem.create(
    quantity: rand(1..5),
    product_id: rand(1..10),
    order_id: rand(1..10)
  )
end

Category.create(name: 'Adult')
Category.create(name: 'Kids')

Product.all.each do |product|
  product.categories << Category.find_by_id(rand(1..2))
  product.save
end

puts "\n\n----Summary----"
puts "#{Product.count} Products"
puts "#{Category.count} Categories"
puts "#{Order.count} Orders"
puts "#{OrderItem.count} OrderItems"
puts "#{User.count} Users"
