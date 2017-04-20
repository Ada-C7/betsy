# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
orders = []

CSV.foreach("orders_seeds.csv", { :headers => true }) do |line|
  drivers << {status: line[0], email: line[1], billing_name: line[2], address: line[3], card_number: line[4], card_exporation: line[5], cvv: line[6], zipcode: line[7], user_id: line[8] }
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
