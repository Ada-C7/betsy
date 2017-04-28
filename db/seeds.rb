# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

merchants = [
  {
    name: "Dan",
    username: "dan",
    email: "dan@betsy.com",
    uid: 12,
    provider: 'github'
  },

  {
    name: "Jamie",
    username: "jamie",
    email: "jamie@betsy.com",
    description: "I make haunting materials that are fun for all ghosts",
    uid: 11,
    provider: 'github'
  },

  {
    name: "Kari",
    username: "kari",
    email: "kari@betsy.com",
    description: "I specialize in scary hats for ghosts",
    uid: 10,
    provider: 'github'
  },

  {
    name: "Chris",
    username: "chris",
    email: "chris@betsy.com",
    description: "I've perfected invisible cheez-its for snacking on the job.",
    uid: 14,
    provider: 'github'
  },

  {
    name: "Casper",
    username: "casper",
    email: "casper@betsy.com",
    description: "Who says haunting has to be mean? I take a friendly approach to being a ghost.",
    uid: 16,
    provider: 'github'
  }

]

merchants.each do |merchant|
  Merchant.create(merchant)
end


categories = [
  { name: "haunting"},
  { name: "anti human"},
  { name: "slime"},
  { name: "sound effects"},
  { name: "curses"},
  { name: "pranks"},
  { name: "chills"},
  { name: "anti-ghost detection"},

]

categories.each do |category|
  Category.create(category)
end

puts Category.all.length

products = [
  {
    name: "Code Ghost",
    price: 10.00,
    quantity: 1000,
    merchant_id: 5,
    description: "Terrorize brogrammers everywhere with code errors that mysteriously disappear and re-appear. Gitmaggedon is upon your enemies.",
    image_url: "http://1.bp.blogspot.com/_NYeAv2POONQ/TERz4A7yV5I/AAAAAAAAAGk/i4o13oWagsA/s400/cap1_0001.jpg"
  },

  { name: "Ghost Hat",
    price: 4.50,
    quantity: 10,
    merchant_id: 2,
    description: "a beautiful spooky hat",
    image_url: "http://www.villagehatshop.com/photos/product/standard/4511390S61882/big-size-hats/victorian-wool-felt-top-hat.jpg",
  },

  { name: "Mirror Lipstick",
    price: 9.95,
    quantity: 1000,
    merchant_id: 3,
    description: "Are you 100% transparent and looking to discreetly scrawl that real-time scary message in the mirror right in front of someone's eyes? We’ve now extended our line of lipstick shades exclusively for this purpose!",
    image_url: "http://suziecheel.com/wp-content/uploads/2016/01/mirror-enough.jpg"
  },

  { name: "mini chalkboard",
    price: 9.95,
    quantity: 6,
    merchant_id: 3,
    description:    "Undersized, handheld chalk board. Sneak up behind someone and drag your 'nails' across this mini-slate. Mobile terror. Be *that* ghost",
    image_url: "http://factorydirectcraft.com/pimages/20120809085805-430997/mini_chalkboards_3.jpg"
  },

  { name: "haunted house",
    price: 300,
    quantity: 1,
    merchant_id: 4,
    description: "move-in ready",
    image_url: "http://www.gafollowers.com/wp-content/uploads/2015/10/342212-haunted-house.jpg"
  },

  { name: "purple crayon",
    price: 2.75,
    quantity: 15,
    merchant_id: 5,
    description: "made from high quality wax",
    image_url: "http://d3d71ba2asa5oz.cloudfront.net/12014628/images/crayonpurple1200.jpg"
  },
  { name: "Levitator",
    price: 11.50,
    quantity: 23,
    merchant_id: 2,
    description: "move objects with ease",
    image_url: "http://www.wilko.com/content/ebiz/wilkinsonplus/invt/0299456/0299456_l.jpg"

  },
  { name: "pumpkin helmet",
    price: 9.75,
    quantity: 15,
    merchant_id: 2,
    description: "perfect for headless ghosts",
    image_url: "http://arts-stew.com/wp-content/uploads/2012/10/Smiling-Halloween-Pumpkins-400x299.jpg"

  },
  { name: "can of spirits",
    price: 4.15,
    quantity: 15,
    merchant_id: 3,
    description: "prank your friends at your next ghostly party. Spirits comein assorted shapes and sizes. Ten per can.",
    image_url: "https://thumbs.dreamstime.com/x/food-can-20374972.jpg"

  },
  { name: "Sugar Bats",
    price: 0.75,
    quantity: 90,
    merchant_id: 4,
    description: "Delicious snack while waiting for your next spooking session",
    image_url: "http://stgeorgecookies.com/wp-content/uploads/2012/10/dsc_0299.jpg"

  },
  { name: "Secret passageway",
    price: 63.45,
    quantity: 7,
    merchant_id: 5,
    description: "Create a portal from the basement to the bathroom with ease. (you don't need this product; you are a ghost who can travel through solid objects).",
    image_url: "http://marshauntedhouse.com/MarsHauntedHouse/Images/home_background.jpg"

  },

  { name: "Casual Friday - 1000 Thread-Count Egyptian Cotton Sheet Set",
    price: 80.00,
    quantity: 10,
    merchant_id: 1,
    description: "Running short on time? Not feeling your look today? Consider going Classic! Get a helping hand from this traditional 1000 threat count egyptian cotton sheet set. Yield: Enough for you and a 'friend'",
    image_url: "http://www.polyvore.com/cgi/img-thing?.out=jpg&size=l&tid=29005250"
  },

  { name: "Animated Skeleton",
    price: 40.00,
    quantity: 37,
    merchant_id: 1,
    description: "Perfect for popping out of backyard pet graves.",
    image_url: "https://cdn.shopify.com/s/files/1/0870/8326/products/harvey_2nd_class_1_large__02526_d353e676-e236-4246-88bf-690550fa149b_large.jpeg?v=1448108932"
  },
  { name: "Army of Ghosts",
    price: 1500.00,
    quantity: 2,
    merchant_id: 3,
    description: "How else can we defeat Sauron?",
    image_url: "https://img.clipartfest.com/e793e59e4e1ed2b6b79506cf68fd4787_3141kb-5942-x-4982-cute-halloween-ghosts-clipart_5942-4982.png"
  },
  { name: "Frog",
    price: 2.00,
    quantity: 72,
    merchant_id: 1,
    description: "Perfect as a gift for the witches and wizards in your life.",
    image_url: "http://kids.nationalgeographic.com/content/dam/kids/photos/articles/Other%20Explore%20Photos/R-Z/Wacky%20Weekend/Frogs/ww-frogs-budgetts.jpg.adapt.945.1.jpg"
  },
  { name: "Balloon Ghost",
    price: 3.50,
    quantity: 73,
    merchant_id: 1,
    description: "Just a balloon that looks like a ghost. What else do you want from me?",
    image_url: "http://4.bp.blogspot.com/-7TrmD9lWnps/VCFRC8JDZJI/AAAAAAAAZ74/FL5yOT7rcQc/s1600/Halloween-Balloons-1.jpg"
  },
  { name: "Potting Wheel",
    price: 400.00,
    quantity: 11,
    merchant_id: 5,
    description: "Use it to woo your love from beyond",
    image_url: "https://c1.staticflickr.com/7/6230/6296252809_76656f781b_b.jpg"

  }



]


Category.all.each do |c|
  puts c.name
  puts c.id
end


products.each do |product|
  p = Product.create(product)
  puts "#{p.name}"
  p.categories << Category.find_by_id(rand(1..4))
  p.categories << Category.find_by_id(rand(5..8))
end
