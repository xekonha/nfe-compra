class XlsImporterAllBase
  def initialize(file_path)
    @file_path = file_path
    # @file_path = "/home/rainey/code/PaxecoL/nfe-compra/tmp/Projeto NFE Origem.xlsx"
    # XlsImporter('/home/rainey/code/PaxecoL/nfe-compra/tmp/contagil', User.last)
    # user:
    # User.where("cpf = '09626770007'")
    # pedido:
    # periodo_inicial = Date.new(2021,1,1)
    # periodo_final = Date.new(2021,11,6)
    # @user = User.new(email: 'abc@rfb.gov.br', password: '123456')
    # @pedido = Pedido.new(user: @user, periodo_inicial: Date.new(2020,1,1), periodo_final: Date.new(2021,11,7)
    # periodo_final = Date.new(2021,11,6))
  end

  def integer?(value)
    Integer(value) && true rescue false
  end

  def import
    @users = User.all
    @chave = 0
    @chaves = []
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 1
    sheet.each_row do |row|
      # Dados da nota sem mercadorias (itens)
      @cpfs = []
      nota = RepoNota.new
      nota.emissao = row[0]
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      @user_now = @users[rand(0...@users.length)]
      # p nota.cpf_destinatario
      nota.nome_destinatario = row[2]
      nota.emitente = row[3]
      nota.nome_emitente = row[4]
      nota.descricao_cfop = row[5]
      nota.numero_nota = row[6]
      nota.chave = row[7].gsub(/\s/, '')
      found_key = false
      if @chaves.length.positive?
        @chaves.each do |v|
          break unless found_key

          if v.real == nota.chave
            nota.chave = v.simulada
            nota.cpf_destinatario = v[:cpfs][:simulado]
            nota.nome_destinatario = User.where("cpf = '#{nota.cpf_destinatario}'")[0].name
            found_key = true
          end
        end
      end
      unless found_key
        @cpfs = { real: nota.cpf_destinatario, simulado: @user_now.cpf }
        nota.nome_destinatario = @user_now.name
        @chave += 10
        @chave_simulada = @chave.to_s.rjust(44, "0")
        @chaves << { real: nota.chave, simulada: @chave_simulada, cpfs: @cpfs }
        nota.chave = @chave_simulada
      end
      binding.pry
      nota.save!
      # Dados das mercadorias (itens)
      item = RepoItemNota.new
      item.repo_nota = nota.id
      item.descricao = row[8]
      item.unidade_comercial = row[9]
      item.quantidade_comercial = row[10]
      if integer?(item.quantidade_comercial)
        item.quantidade_comercial = item.quantidade_comercial.to_i
        item.quantidade_comercial = (item.quantidade_comercial * rand(1..3))
      else
        item.quantidade_comercial = item.quantidade_comercial.to_f
        item.quantidade_comercial = (item.quantidade_comercial * rand(1..3)).truncate(2)
      end
      item.valor_unitario = row[11].to_f
      item.valor_unitario = item.valor_unitario * rand(1.0..3.0).truncate(2)
      item.valor_total = (item.valor_unitario * item.quantidade_comercial).truncate(2)
      item.save!
    end
  end
end
