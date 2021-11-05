class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if cpf_valid?(value)

    record.errors.add(
      attribute,
      :invalid_cpf,
      message: options[:message] || 'is not valid',
      value: value
    )
  end

  private

  DENY_LIST = %w[
    00000000000
    11111111111
    22222222222
    33333333333
    44444444444
    55555555555
    66666666666
    77777777777
    88888888888
    99999999999
    12345678909
    01234567890
  ].freeze

  SIZE_VALIDATION = /^[0-9]{11}$/

  def cpf_valid?(cpf)
    cpf.gsub!(/[^\d]/, '')
    return unless cpf =~ SIZE_VALIDATION
    return if DENY_LIST.include?(cpf)

    cpf_numbers = cpf.chars.map(&:to_i)
    first_digit_valid?(cpf_numbers) && second_digit_valid?(cpf_numbers)
  end

  def first_digit_valid?(cpf_numbers)
    first_digits = cpf_numbers[0..9]
    multiplied = first_digits.map.with_index do |number, index|
      number * (10 - index)
    end

    mod = multiplied.reduce(:+) % 11

    fst_verifier_digit = 11 - mod > 9 ? 0 : mod
    fst_verifier_digit == cpf_numbers[10]
  end

  def second_digit_valid?(cpf_numbers)
    second_digits = cpf_numbers[0..10]
    multiplied = second_digits.map.with_index do |number, index|
      number * (11 - index)
    end

    mod = multiplied.reduce(:+) % 11

    snd_verifier_digit = 11 - mod > 9 ? 0 : mod
    snd_verifier_digit == cpf_numbers[11]
  end

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
  # # cpfs = ['046158553115', '01159226105', '05031049812', '04643573490', '46-15.85    53....1----15 ']

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

end
