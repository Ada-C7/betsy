# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Merchant.create(username: "Bob", email: "em1@gmail.com")
Merchant.create(username: "Karen", email: "em2@gmail.com")
Merchant.create(username: "May", email: "em3gmail.com")
Merchant.create(username: "Eve", email: "em4@gmail.com")
Merchant.create(username: "Harry", email: "em5@gmail.com")
Merchant.create(username: "Mary", email: "em6@gmail.com")


Product.create(merchant_id: 1, name: "Shrimp on avocado bed", price: 16.50, inventory: 3, image: "NomNom.png", category: "veggies", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. Pellentesque commodo ipsum ac tincidunt elementum. Fusce volutpat at nisl vel pellentesque.")
Product.create(merchant_id: 5, name: "Plain mandarine", price: 4.50, inventory: 3, image: "NomNom.png", category: "dessert", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. Pellentesque commodo ipsum ac tincidunt elementum. Fusce volutpat at nisl vel pellentesque.")
Product.create(merchant_id: 2, name: "Salmon & greens", price: 12.50, inventory: 5, image: "NomNom.png", category: "protein_from_the_see", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 5, name: "Soup of potatoes", price: 4.30, inventory: 10, image: "NomNom.png", category: "soup", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 1, name: "A delicious bite", price: 5.30, inventory: 4, image: "NomNom.png", category: "protein_from_the_see", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 2, name: "Figs on a plate", price: 6.70, inventory: 10, image: "NomNom.png", category: "dessert", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 3, name: "Cupcake a la rose", price: 10.40, inventory: 5, image: "NomNom.pngb", category: "soup", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 4, name: "Caprese tower", price: 9.80, inventory: 3, image: "NomNom.png", category: "soup", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 5, name: "Gravad lax on crackers", price: 8.30, inventory: 4, image: "NomNom.png", category: "soup", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 3, name: "Pappardelle mushroom speciale", price: 12.50, inventory: 6, image: "NomNom.png", category: "soup", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")
Product.create(merchant_id: 3, name: "Exquisite red", price: 13.30, inventory: 1, image: "NomNom.png", category: "soup", status: "active",  description: "Pellentesque congue odio semper pellentesque viverra. ")



Category.create(name: "fish") # 1
Category.create(name: "veggies") # 2
Category.create(name: "pork") # 3
Category.create(name: "salad") # 4
Category.create(name: "meat") # 5
Category.create(name: "vegan") # 6
Category.create(name: "gluten free") # 7
Category.create(name: "poultry") # 8

Category.create(name: "dinner") # 9
Category.create(name: "breakfast") # 10
Category.create(name: "snack") # 11

Category.create(name: "main course") # 12
Category.create(name: "appetizer") # 13
Category.create(name: "dessert") # 14

Category.create(name: "fruit") # 15
Category.create(name: "soup") # 16



Product.find(1).categories << Category.find(1)
Product.find(1).categories << Category.find(12)
Product.find(1).categories << Category.find(9)

Product.find(2).categories << Category.find(15)
Product.find(2).categories << Category.find(14)

Product.find(4).categories << Category.find(16)
Product.find(4).categories << Category.find(6)
