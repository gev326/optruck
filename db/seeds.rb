
users = [
  {
    :first_name => 'Admin',
    :last_name => 'Admin',
    :email => 'admin@admin.com',
    :account_type => 'admin',
    :password => 'admin123'
  },
]

User.delete_all

users.each do |u|
  User.create(u)
end

# current_user = User.first

# drivers = []

# 10.times do
#   covered = [true, false].sample
#   id = covered ? current_user.id : nil
#   driver = {
#     :first_name => Faker::Name.first_name,
#     :last_name => Faker::Name.last_name,
#     :current_state => Faker::Address.state,
#     :desired_state => Faker::Address.state,
#     :driver_id_tag => Faker::Number.number(6),
#     :driver_phone => Faker::Number.number(10),
#     :contact_name => Faker::Name.first_name,
#     :driver_truck_type => ['53R', '53RM', '53V', '53VM', 'flat', '48R', '48V'].sample,
#     :active => [true, false].sample,
#     :driver_company => Faker::Company.name,
#     :Covered => covered,
#     :Etrac => [true, false].sample,
#     :PlateTrailer => [true, false].sample,
#     :user_id => id,
#     :insurance =>Faker::Company.name
#   }
#   drivers.push(driver)
# end

# Driver.delete_all
# drivers.each do |d|
#   Driver.create(d)
# end

# puts "Successfully added #{drivers.length} drivers to database"
