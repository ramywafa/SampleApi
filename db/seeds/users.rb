puts 'Seeding User...'
a = User.create! do |user|
  user.email = 'bob@gmail.com'
  user.password = 'ramywafa'
end

puts "* Email    : #{a.email}"
puts "* Password : #{a.password}"
