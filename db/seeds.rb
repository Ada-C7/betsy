# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "csv"

CSV.read("support/vendors_seeds.csv", {:headers => true}).each do |data|
  args = {
          :uid => data[1],
          :provider => data[2],
          :email => data[3],
          :username => data[4]
        }
  Vendor.create(args)
end

CSV.read("support/products_seeds.csv", {:headers => true}).each do |data|
  args = {
          :vendor_id => data[1],
          :name => data[2],
          :description => data[3],
          :photo_url => data[4],
          :price => data[5],
          :quantity => data[6]
        }
  Product.create(args)
end

CSV.read("support/reviews_seeds.csv", {:headers => true}).each do |data|
  args = {
          :product_id => data[1],
          :rating => data[2],
          :comment => data[3]
        }
  Review.create(args)
end

CSV.read("support/categories_seeds.csv", {:headers => true}).each do |data|
  args = {
          :label => data[1]
        }
  Category.create(args)
end

# CSV.read("support/reviews_seeds.csv", {:headers => true}).each do |data|
#   args = {
#           :category_id => data[1],
#           :product_id => data[2],
#         }
#   CategoryProduct.create(args)
# end
