class ProductOrder < ApplicationRecord
  belongs_to :order, optional: false
  belongs_to :product, optional: false
end
