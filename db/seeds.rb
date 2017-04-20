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
