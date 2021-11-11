class XlsImporter
  def initialize(file_path)
    @file_path = file_path
  end

  def import
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 1
    sheet.each_row do |row|
      nota = Nota.new
      nota.emissao = row[0]
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      @user = User.where(cpf: nota.cpf_destinatario).first_or_create! do |user|
                user.password = '123456'
                user.name = "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.last_name}"
                user.email = Faker::Internet.email
              end
      @pedido = Pedido.where(user: @user).first_or_create! do |pedido|
                  pedido.periodo_inicial = Date.new(2020,11,8)
                  pedido.periodo_final = Date.new(2021,11,7)
                  pedido.data_pedido = Date.new(2021,11,7)
                  pedido.situacao = 'disponivel'
                end
      nota.nome_destinatario = row[2]
      nota.emitente = row[3]
      nota.nome_emitente = row[4]
      nota.descricao_cfop = row[5]
      nota.numero_nota = row[6]
      nota.chave = row[7].gsub(/\s/, '')
      nota.pedido = @pedido
      nota.save!
    end
  end
end
