# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times {
  @user = User.new
  @user.email = Faker::Internet.email
  @user.password = '123456'
  @user.cpf = Faker::CPF.numeric
  @user.name = Faker::Name.name
  raise
  @user.save
}
