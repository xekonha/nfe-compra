class XlsImporter
  def initialize(file_path, pedido)
    @file_path = file_path
    @pedido = pedido
  end

  def import
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 1
    sheet.each_row do |row|
      nota = Nota.new
      nota.emissao = row[0]
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      p nota.cpf_destinatario
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
