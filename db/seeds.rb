require 'csv'
product_file = Rails.root.join('db', 'product_seeds.csv')
merchant_file = Rails.root.join('db', 'merchant_seeds.csv')


CSV.foreach(merchant_file, headers: true, header_converters: :symbol, converters: :all, skip_blanks: false) do |row|
  data = Hash[row.headers.zip(row.fields)]
  Merchant.create!(data)
end

CSV.foreach(product_file, headers: true, header_converters: :symbol, converters: :all, skip_blanks: false) do |row|
  data = Hash[row.headers.zip(row.fields)]
  Product.create!(data)
end
