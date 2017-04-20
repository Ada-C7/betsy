require 'csv'

products_array = []
CSV.read("db/products.csv", headers: true).map do |line|
  product = {user_id: line[1], name: line[2], quantity: line[3], price: line[4], description: line[5], image_url: line[6]}
  products_array << product
end

products_array.each do |product|
  new_product = Product.create!(product)
  if !new_product.id
    puts "couldn't create product #{product.name}"
  end
end

orders = []

CSV.foreach("db/orders_seeds.csv", { :headers => true }) do |line|
  orders << {status: line[0], email: line[1], billing_name: line[2], address: line[3], card_number: line[4], card_exporation: line[5], cvv: line[6], zipcode: line[7], user_id: line[8] }
end

success_count = 0

orders.each do |order|
  temp_order = Order.create(order)
  if temp_order.id
    success_count += 1
    puts "#{temp_order.email} successfully added"
  end
end

puts "#{success_count} out of #{orders.length} successfully added"
