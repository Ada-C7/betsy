# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# READ ME:
# you may want to delete all users you have and all products you have
# the products have user ids 1-10, because there are 10 users in the seed data
# but if you don't care, don't worry about it!

require 'csv'

CSV.read("db/users.csv", headers: true).map do |line|
  new_user = User.create(username: line[0], email: line[1], uid: line[2], provider: line[3])
  if !new_user.id
    puts "couldn't create user #{new_user.username}"
  end
end

CSV.read("db/categories.csv", headers: true).map do |line|
    new_category = Category.create(name: line[0], photo: line[1])
    if !new_category.id
        puts "couldn't create category #{new_category.name}"
        puts new_category.errors.messages
    end
end

CSV.read("db/products.csv", headers: true).map do |line|
    new_product = Product.create(user_id: line[0].to_i, name: line[1], description: line[2], selling_status: true, price: line[3].to_f.round(2), photo_url: line[4], stock: line[5].to_i, category_ids: [line[6], line[7]])

    if !new_product.id
        puts "couldn't create product #{new_product.name}"
        puts new_product.errors.messages
    end
end

50.times do
  new_order_item = OrderItem.new(product_id: rand(1..24), order_id: rand(1..20))
  product = Product.find(new_order_item.product_id)
  new_order_item.quantity = rand(1..product.stock)
  new_order_item.save
  if !new_order_item.id
    puts "couldn't create orderitem of #{new_order_item.quantity}#{product.name.pluralize}"
    puts new_order_item.errors.messages
  end
end

20.times do
  cons = %w( b c d f g h j k l m n p q r s t v w x z )
  vows = %w( a e i o u y )
  new_order = Order.new
  n = 1
  orderitems = OrderItem.where(order_id: n)
  new_order.order_items = orderitems
  new_order.status = "paid"
  new_order.email = "#{cons.sample}@#{cons.sample}#{vows.sample}#{cons.sample}.fake"
  new_order.address = "#{rand(1..100)} #{["E","W","S","N"].sample} #{%w(fake real nope notgonnahappen fairyland silly haha).sample.capitalize} #{["Ave","Street","Way","Blvd"].sample}"
  new_order.name_on_cc = "#{vows.sample.capitalize}#{cons.sample}#{vows.sample} #{cons.sample.capitalize}#{vows.sample}"
  new_order.cc_number = (1..9).to_a.shuffle[0,4].join.to_i
  new_order.cc_ccv = (1..9).to_a.shuffle[0,3].join.to_i
  new_order.billing_zip = (1..9).to_a.shuffle[0,5].join.to_i
  new_order.save
  if !new_order.id
    puts "couldn't create order"
    puts new_order.errors.messages
  end
  n += 1
end

#reviews
100.times do
  exclamations = %w( wow yikes sheesh dang no yes terrible wonderful amazing )
  adjectives = %w( good bad stinky hot flavorful uncertain hottening flatly kindness pink forkful evenly makely flyful candidly hopeful gimmicky)
  nouns = %w( edge hard thought sleep dream fish rest end facet marinade stirring boom )
  first_words = %w( such much so very many)
  sayings  = ["Can't.", "No way.", "Why.", "Must one.", "Can you believe.", "Not buy.", "Wow."]
  new_review = Review.new(product_id: rand(1..24))
  new_review.title = "#{exclamations.sample.capitalize}!"
  new_review.rating = rand(1..5)
  new_review.review_text = "#{first_words.sample.capitalize} #{adjectives.sample}. #{first_words.sample.capitalize} #{nouns.sample}. #{sayings.sample}"
  new_review.save
  if !new_review.id
    puts "couldn't create review"
    puts new_review.errors.messages
  end
end




# CSV.read("db/categories_products.csv", headers: true).map do |line|
#     new_category_product = Category.create(name: line[0])
#     if !new_category.id
#         puts "couldn't create category #{new_category.name}"
#         puts new_category.errors.messages
#     end
# end
