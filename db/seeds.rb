# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'faker'

users = [
  {
    :first_name => 'Admin',
    :last_name => 'Admin',
    :email => 'admin@admin.com',
    :account_type => 'admin',
    :password => 'admin666'
  },
]

User.delete_all

users.each do |u|
  User.create(u)
end

drivers = []

50.times do
  driver = {
    :first_name => Faker::Name.first_name,
    :last_name => Faker::Name.last_name,
    :current_state => Faker::Address.state,
    :desired_state => Faker::Address.state,
    :driver_id_tag => Faker::Number.number(6),
    :driver_phone => Faker::Number.number(10),
    :driver_truck_type => ['r53', 'flat'].sample,
    :driver_contract_number => Faker::Number.number(5),
    :active => [true, false].sample,
    :driver_company => Faker::Company.name,
    :backhaul => [true, false].sample,
    :Covered => [true, false].sample,
    :reeferunit => [true, false].sample,
    :insurance =>Faker::Company.name
  }
  drivers.push(driver)
end

Driver.delete_all
drivers.each do |d|
  Driver.create(d)
end

puts "Successfully added #{drivers.length} drivers to database"
