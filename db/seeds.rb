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
  @user.save!
}
# require 'faker/cpf'
# require 'pry-byebug'

# def verify_digits(cpf)
#   # puts "CPF #{cpf} #{cpf_iterate(cpf, 10)} #{cpf_iterate(cpf, 11)}"
#   digit(cpf_iterate(cpf, 10)).to_s == cpf[-2] && digit(cpf_iterate(cpf, 11)).to_s == cpf[-1]
# end

# def cpf_iterate(cpf_str, multiplier)
#   cpf_str = cpf_str[0...multiplier - 1]
#   one_digit = 0
#   cpf_str.chars.each_with_index do |digit, index|
#     unless index > cpf_str.length - 1
#       one_digit += digit.to_i * multiplier
#       multiplier -= 1
#     end
#   end
#   return one_digit
# end

# def digit(value)
#   case value % 11
#   when 0, 1
#     return 0
#   else
#     return 11 - (value % 11)
#   end
# end

# # VÁLIDOS
# # cpfs = ['46158553115', '01159226105', '05031049812', '04643573490']

# # INVÁLIDOS
# # cpfs = ['46158553151', '01159226100', '05031049822', '04643573499']

# # VÁLIDOS NUMÉRICOS
# cpfs = ['046158553115', '01159226105', '05031049812', '04643573490', '46-15.85    53....1----15 ']

# # INVÁLIDOS NUMÉRICOS

# def cpf_std(cpf)
#   return cpf.gsub(/\s+/, "").gsub(/\.+/, "").gsub(/-+/, "")
# end

# def check_cpf(cpf)
#   verify_digits(cpf_std(cpf))
# end

# cpfs = []
# 100.times do
#   cpf_fake = Faker::CPF.number
#   cpfs << { numero: cpf_fake, dig_security: check_cpf(cpf_fake), tipo: "fake" }
# end

# ['046158553115', '01159226105', '05031049812', '04643573490', '46-15.85    53....1----15 '].each do |i|
#   cpfs << { numero: cpf_std(i), dig_security: check_cpf(i), tipo: "grupo" }
# end

# cpfs.each_with_index do |cpf, index|
#   if cpf[:dig_security]
#     puts "#{index + 1}-CPF #{cpf[:numero][0..2]}.#{cpf[:numero][3..5]}.#{cpf[:numero][6..8]}-#{cpf[:numero][9..10]}. \
#     Dígito: #{cpf[:dig_security]}. Tipo: #{cpf[:tipo]}."
#   else
#     puts "#{index + 1}-CPF #{cpf[:numero]}. Dígito: #{cpf[:dig_security]}. Tipo: #{cpf[:tipo]}."
#   end
# end
