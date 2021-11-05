class XlsImporter
  def initialize(file_path, pedido)
    @file_path = file_path
    @pedido = pedido
  end

  def import
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.each_row do |row|
      nota = Nota.new
      nota.emissao = row[0]
      nota.cpf_destinatario = row[1].tr('^0-9', '')
      nota.nome_destinatario = row[2]
      nota.emitente = row[3]
      nota.nome_emitente = row[4]
      nota.descricao_cfop = row[5]
      nota.numero_nota = row[6]
      nota.chave = row[7]
    end
  end
end

user = User.new("email" => "rainey.lopes@gmail.com", "password" => "123456")

pedido = Pedido.new("periodo_inicial" => Date.new(2021, 1, 2), "periodo_final" => Date.new(2021, 3, 2),
                     "data_pedido" => DateTime.now, "situacao" => "pronto", "data_resposta" => (DateTime.now + 6.day))
pedido.user = user
