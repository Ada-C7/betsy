require 'csv'

csv_text_m = File.read(Rails.root.join('support', 'merchants.csv' ))
csv_m = CSV.parse(csv_text_m, :headers => true)
  csv_m.each do |row|
    m = Merchant.new
    m.name = row[0]
    m.username = row[1]
    m.email = row[2]
    m.save
  end

  csv_text_pa = File.read(Rails.root.join('support', 'products.csv' ))
  csv_pa = CSV.parse(csv_text_pa, :headers => true)
    csv_pa.each do |row|
      pa = Product.new
      pa.name = row[0]
      pa.description = row[1]
      pa.quantity = row[2]
      pa.price = row[3]
      pa.merchant_id = row[4]
      pa.save
    end

    csv_text_r = File.read(Rails.root.join('support', 'reviews.csv' ))
    csv_r = CSV.parse(csv_text_r, :headers => true)
      csv_r.each do |row|
        r = Review.new
        r.rating = row[0]
        r.comment = row[1]
        r.name = row[2]
        r.product_id = row[3]
        r.save
      end

      csv_text_op = File.read(Rails.root.join('support', 'order_products.csv' ))
      csv_op = CSV.parse(csv_text_op, :headers => true)
        csv_op.each do |row|
          op = OrderProduct.new
          op.product_id = row[0]
          op.quantity = row[1]
          op.order_id = row[2]
          op.save
        end

        csv_text_o = File.read(Rails.root.join('support', 'orders.csv' ))
        csv_o = CSV.parse(csv_text_o, :headers => true)
          csv_o.each do |row|
            o = Order.new
            o.status = row[0]
            o.save
          end
