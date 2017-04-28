class Category < ApplicationRecord
    has_and_belongs_to_many :products

    validates :name, presence: true, uniqueness: true

    # def self.to_csv
    #   attributes = %w(id name )
    #   CSV.generate( headers: true ) do |csv|
    #     csv << attributes
    #
    #     all.each do |category|
    #       csv << category.attributes.values_at(*attributes)
    #     end
    #   end
    # end
end
