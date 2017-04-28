
Category.destroy_all
Product.destroy_all
Merchant.destroy_all


10.times do
  category = Category.new
  category.name = Faker::Pokemon.name
  category.save!
end

10.times do
  merchant = Merchant.new
  merchant.username = Faker::Name.first_name
  merchant.email = Faker::Internet.email
  merchant.save!
end

10.times do |i|
  product = Product.new
  product.name ="product_##{i}"
  product.price = Faker::Number.decimal(2)
  product.photo_url = "category_img/#{rand(12)}.jpg"
  product.description = Faker::Lorem.paragraph
  product.stock = rand(1..10)
  product.merchant_id = Merchant.all.sample.id
  product.categories = Category.all.sample
  product.save!
  # product_category = ProductCategory.create({:category_id => Category.all.sample.id, :product_id => product.id})
end


# require 'csv'

# Merchant.destroy_all
# Product.destroy_all


# Owlicious = Merchant.create({username: "Owlicious", email:"yummy@owl.net"})
# SleepytHoots = Merchant.create({username: "SleepyHoots", email:"sleepy@owl.net"})


# products_file = Rails.root.join('db', 'product_seeds.csv')

# CSV.foreach(products_file, headers: true) do |row|
#   Product.create!(name: row['name'], price: row['price'], photo_url: row['photo_url'], description: row['description'], stock: row['stock'],merchant_id:11)
# end

#Merchant.find_by(username: "SleepyHoots")
# new_products.each do |product|
#    product.merchant =  Merchant.find_by(username: "SleepyHoots")
#    product.save
# end


# p = Product.create(name:"owl-with-glasses-duve", price: 40, photo_url: "owl_glasses_duvet", description: "Look ma, I'm sleeping!", stock: 12, merchant: Merchant.find_by(username:"SleepyHoots"))

# p = Product.new(name:"OWL", price: 40, photo_url: "owl_glasses_duvet", description: "Look ma, I'm sleeping!", stock: 12, )

#product_category = ProductCategory.create({:category_id => Category.all.sample.id, :product_id => product.id})
#end
