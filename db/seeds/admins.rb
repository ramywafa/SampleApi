puts 'Seeding Admin...'
a = Admin.create! do |admin|
  admin.email = 'ramy.wafa@gmail.com'
  admin.password = 'ramywafa'
end

puts "* Email    : #{a.email}"
puts "* Password : #{a.password}"
