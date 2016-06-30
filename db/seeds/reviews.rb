puts 'Seeding reviews...'
a = Review.create! do |review|
  review.rating = 5
  review.content = 'Awesome review for dish'
  review.reviewer = Admin.first
  review.dish = Dish.last
end

puts "* rating  : #{a.rating}"
puts "* content : #{a.content}"

a = Review.create! do |review|
  review.rating = 1
  review.content = 'Awful dish'
  review.reviewer = User.first
  review.dish = Dish.first
end

puts "* rating  : #{a.rating}"
puts "* content : #{a.content}"

puts "-" * 10
puts "Seeded #{Review.count} reviews"
