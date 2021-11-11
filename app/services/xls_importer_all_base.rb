class XlsImporterAllBase
  def initialize(file_path)
    @file_path = file_path
  end

  def cfop
    # cfop = XlsImporterAllBase.new("/home/rainey/code/PaxecoL/nfe-compra/tmp/CFOP.xlsx")
    cfops = {}
    cfop_dados = {}
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 1
    sheet.each_row do |row|
      # CFOP -> Descricao
      cfop_number = row[0]
      if cfop_number.nil?
        break
      end
      cfop_descricao = row[1]
      cfop_descricao = I18n.transliterate(cfop_descricao.titleize.gsub(" ", "_"))
      cfops[cfop_descricao] = [] unless cfops.key?(cfop_descricao)
      cfops[cfop_descricao] << cfop_number
      cfop_dados[:cfop_descricao] = {}
      cfop_dados[:cfop_descricao]['remessa'] = row[2]
      cfop_dados[:cfop_descricao]['exportacao'] = row[3]
      cfop_dados[:cfop_descricao]['importacao'] = row[4]
      cfop_dados[:cfop_descricao]['compra'] = row[5]
      cfop_dados[:cfop_descricao]['RB'] = row[6]
      cfop_dados[:cfop_descricao]['devolucao'] = row[7]
      cfop_dados[:cfop_descricao]['retorno'] = row[8]
      cfop_dados[:cfop_descricao]['anula_vlr'] = row[9]
    end
    reponotas = RepoNota.all
    cfops_coincidentes = []
    reponotas.each do |reponota|
      descricao = I18n.transliterate(reponota.descricao_cfop.titleize.gsub(" ", "_"))
      if cfops.key?(descricao)
        cfops_coincidentes << reponota if cfops[descricao].length > 1
      else
        binding.pry
      end
    end
  end

  def import
  # Registers Users
    @chave = 100000
    @chaves = {}
    @users = User.all
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 99000
    sheet.each_row do |row|
      # Dados da nota sem mercadorias (itens)
      nota = RepoNota.new
      nota.emissao = row[0]
      if nota.emissao.nil?
        break
      end
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      @user_now = @users[rand(0...@users.length)]
      nota.nome_destinatario = row[2]
      nota.emitente = row[3]
      nota.nome_emitente = row[4]
      nota.descricao_cfop = row[5]
      nota.numero_nota = row[6].to_i
      chave_tmp = row[7]
      nota.chave = chave_tmp.gsub(/\s/, '')
      if @chaves.keys.include?(nota.chave)
        nota = RepoNota.where("chave = '#{@chaves[nota.chave]}'")[0]
      else
        nota.cpf_destinatario = @user_now.cpf
        nota.nome_destinatario = @user_now.name
        @chave += 10
        @chave_simulada = @chave.to_s.rjust(44, "0")
        @chaves[nota.chave] = @chave_simulada
        nota.chave = @chave_simulada
        nota.save!
      end
      # Dados das mercadorias (itens da NFe)
      item = RepoItemNota.new
      item.repo_nota = nota
      item.descricao = row[8]
      item.unidade_comercial = row[9]
      item.quantidade_comercial = row[10]
      item.quantidade_comercial = item.quantidade_comercial.to_f
      item.quantidade_comercial = (item.quantidade_comercial * rand(1..3)).truncate(2)
      item.valor_unitario = row[11].to_f
      item.valor_unitario = (item.valor_unitario * rand(1.0..3.0)).truncate(2)
      item.valor_total = (item.valor_unitario * item.quantidade_comercial).truncate(2)
      item.save!
    end
  end

  def unknown
    # NOT registers users
    @chave = 0
    @chaves = {}
    cpfs = {}
    nomes = {}
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    sheet.row_skip = 99000
    sheet.each_row do |row|
      # Dados da nota sem mercadorias (itens)
      nota = RepoNota.new
      nota.emissao = row[0]
      if nota.emissao.nil?
        break
      end
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      nota.nome_destinatario = row[2]
      if cpfs.keys.include?(nota.cpf_destinatario)
        nota.nome_destinatario = nomes[nota.cpf_destinatario]
        nota.cpf_destinatario = cpfs[nota.cpf_destinatario]
      else
        cpfs[nota.cpf_destinatario] = Faker::CPF.numeric
        nomes[nota.cpf_destinatario] = "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.last_name}"
        nota.nome_destinatario = nomes[nota.cpf_destinatario]
        nota.cpf_destinatario = cpfs[nota.cpf_destinatario]
      end
      nota.emitente = row[3]
      nota.nome_emitente = row[4]
      nota.descricao_cfop = row[5]
      nota.numero_nota = row[6].to_i
      chave_tmp = row[7]
      nota.chave = chave_tmp.gsub(/\s/, '')
      if @chaves.keys.include?(nota.chave)
        nota = RepoNota.where("chave = '#{@chaves[nota.chave]}'")[0]
      else
        @chave += 10
        @chave_simulada = @chave.to_s.rjust(44, "0")
        @chaves[nota.chave] = @chave_simulada
        nota.chave = @chave_simulada
        nota.save!
      end
      # Dados das mercadorias (itens da NFe)
      item = RepoItemNota.new
      item.repo_nota = nota
      item.descricao = row[8]
      item.unidade_comercial = row[9]
      item.unidade_comercial = '-' if item.unidade_comercial.blank?
      item.quantidade_comercial = row[10]
      item.quantidade_comercial = item.quantidade_comercial.to_f
      item.quantidade_comercial = (item.quantidade_comercial * rand(1..3)).truncate(2)
      item.valor_unitario = row[11].to_f
      item.valor_unitario = (item.valor_unitario * rand(1.0..3.0)).truncate(2)
      item.valor_total = (item.valor_unitario * item.quantidade_comercial).truncate(2)
      item.save!
    end
  end
end
