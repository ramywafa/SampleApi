puts 'Seeding dishes...'
a = Dish.create! do |dish|
  dish.name = 'Maccaroni and cheese'
  dish.description = 'Dish created by admin'
  dish.creator = Admin.first
end

puts "* name        : #{a.name}"
puts "* description : #{a.description}"

a = Dish.create! do |dish|
  dish.name = 'Margerita Pizza'
  dish.description = 'Dish created by user'
  dish.creator = User.first
end

puts "* name        : #{a.name}"
puts "* description : #{a.description}"

puts "-" * 10
puts "Seeded #{Dish.count} dishes"
