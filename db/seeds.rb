# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:      "Brent Pendergraft",
      			 email:     "myemail@domain.com",
      			 city:      "SomeCity",
             state:     "Texas",
             job_title: "Some Job",
             company_or_organization: "some company",
      			 password:  "foobar",
      			 password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "email-#{n+1}@domain.com"
  city  = Faker::Address.city
  state = Faker::Address.state
  job_title = Faker::Name.title
  company = Faker::Company.name
  password = "password"
  User.create!(name:  name,
               email: email,
               city:  city, 
               state: state,
               job_title: job_title,
               company_or_organization: company,
               password:                password,
               password_confirmation:   password)
end