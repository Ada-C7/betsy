# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'faker'

categories = %w(Accessories Wearables Food Decor Misc Tech)
categories.each do |name|
  Category.create(name: name)
end

# create 10 random sellers
10.times do
    User.create!(
        username: Faker::Name.unique.first_name,
        email: Faker::Internet.email
    )
end

# 38 Products from CSV
product_data = File.read(Rails.root.join('lib', 'seeds', 'product.csv'))

product_csv = CSV.parse(product_data, :headers => true)
product_csv.each do |row|
  product = Product.new
  product.status = true
  product.name = row['name']
  product.description = row['description']
  product.photo = row['photo']
  product.price = row['price']
  product.user_id = row['user_id']
  product.stock = row['stock']
  product.save!
end

# Create 50 random reviews
50.times do
    Review.create!(
        rating: Faker::Number.between(1, 5),
        comment: Faker::ChuckNorris.fact,
        product_id: Faker::Number.between(1, 38)
    )
end

# JOIN TABLES

# 38 ProductCategory from CSV
join_data = File.read(Rails.root.join('lib', 'seeds', 'productscategory.csv'))

join_csv = CSV.parse(join_data, :headers => true)
join_csv.each do |row|
  categorize = ProductCategory.new
  categorize.category_id = row['category_id']
  categorize.product_id = row['product_id']
  categorize.save!
end
