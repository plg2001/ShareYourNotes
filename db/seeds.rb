# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



i = 81

while i <= 100
  user = User.create(name: "test"+i.to_s, username: "test"+i.to_s,email: "test"+ i.to_s+ "@gmail.com",password: "test12345",password_confirmation: "test12345",
  last_seen: "2023-09-01 18:45:52.106063000 +0000")
  user.skip_confirmation!
  user.save!
  i += 1
end