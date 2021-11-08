class XlsImporter
  def initialize(file_path, pedido)
    file_path "/home/rainey/code/PaxecoL/nfe-compra/tmp/contagil"
    # XlsImporter('/home/rainey/code/PaxecoL/nfe-compra/tmp/contagil', User.last)
    # user:
    # User.where("cpf = '09626770007'")
    # pedido:
    #
    # pedido:
    # periodo_inicial = Date.new(2021,1,1)
    # periodo_final = Date.new(2021,11,6)
    @file_path = file_path
    @user = User.new(email: 'abc@rfb.gov.br', password: '123456')
    @pedido = Pedido.new(user: @user, periodo_inicial: Date.new(2020,1,1), periodo_final: Date.new(2021,11,7)
    # periodo_final = Date.new(2021,11,6))
  end

  def import
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 1
    sheet.each_row do |row|
      nota = Nota.new
      nota.emissao = row[0]
      # date
      @d = emissao
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      p nota.cpf_destinatario
      @user.cpf = cpf_destinatario

      @pedido.situacao = 'disponivel'
      # date-time
      @pedido.data_pedido =
      @pedido.data_resposta = @d.since(rand(0...3600*24))
      # date
      @pedido.periodo_inicial =
      @pedido.periodo_final =


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
