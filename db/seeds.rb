require 'csv'

users = CSV.read(
  "db/support/users.csv",
  headers: true,
  header_converters: :symbol
).map { |line| line.to_h }

users.each do |user|
  new_user = User.create!(user)
  if !new_user.id
    puts "Could not create user #{user.name}"
  end
end
