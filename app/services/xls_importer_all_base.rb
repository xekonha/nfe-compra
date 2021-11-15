class XlsImporterAllBase
  def initialize(file_path, lines_to_skip)
    @file_path = file_path
    @lines_to_skip = lines_to_skip
  end

  def qtd_nota_mercadorias
    qtd_itens = {}
    rn = RepoNota.all
    irn = RepoNotaItem.all
    rn.each do |reponota|
      qtd_itens[reponota.id] = irn.where(repo_nota_id: reponota.id).count
    end
    qtd_itens.keys.each do |key|
      if qtd_itens[key] > 1
        puts "id:#{key} - #{qtd_itens[key]}"
      end
    end
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
    sheet.row_skip = lines_to_skip
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
        # @chave += 10
        # @chave_simulada = @chave.to_s.rjust(44, "0")
        @chave_simulada = nota.chave.chars.shuffle.join
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

  def ped_n_coinc
    # Organiza de uma forma contínua, linear no tempo, os períodos inicial e final de cada pedido de nota,
    # para cada STATUS_PEDIDO = ['pendente', 'disponível', 'concluído'].
    #
    # ped_n_coinc = XlsImporterAllBase.new("/home/rainey/code/PaxecoL/nfe-compra/tmp/CFOP.xlsx")
    # Obtem todos os pedidos para cada usuário, de acordo com o STATUS_PEDIDO.
    pedidobycpf = {}
    todos_os_pedidos = Pedido.all
    todos_os_pedidos.each do |pedido|
      pedidobycpf[pedido.user.cpf] = {} unless pedidobycpf.key?(pedido.user.cpf)
      pedidobycpf[pedido.user.cpf][pedido.situacao] = [] unless pedidobycpf[pedido.user.cpf].key?(pedido.situacao)
      pedidobycpf[pedido.user.cpf][pedido.situacao] << { pi: pedido.periodo_inicial, pf: pedido.periodo_final }
    end
    # Ordena os pedidos de forma crescente de acordo com o período inicial,
    # para cada usuário e para cada STATUS_PEDIDO.
    pedidos_user = {}
    todos_os_usuarios = User.all
    todos_os_usuarios.each do |user|
      ['pendente', 'disponível', 'concluída'].each do |situacao|
        if pedidobycpf.key?(user.cpf) && pedidobycpf[user.cpf].key?(situacao)
          pi = []
          pedidobycpf[user.cpf][situacao].each do |pedido|
            pi << pedido[:pi]
          end
          pclass = []
          pi.sort.uniq.each do |inicio|
            pedidobycpf[user.cpf][situacao].each do |origem|
              if origem[:pi] == inicio
                pclass << {pi: inicio, pf: origem[:pf]}
              end
            end
          end

          # Nesta fase, calcula os tempos de uma forma continuada, desconsiderando, por exemplo,
          # os períodos contidos em outros maiores ou tomando-os como contínuos quando possível.
          pedidos_user[user.cpf] = {} unless pedidos_user.key?(user.cpf)
          pedidos_user[user.cpf][situacao] = [] unless pedidos_user[user.cpf].key?(situacao)
          index = 0
          length = pclass.length
          new_pclass = []
          item = {}
          item[:pi] = pclass[0][:pi]
          item[:pf] = pclass[0][:pf]
          while index + 1 < length
            if item[:pf] < pclass[index + 1][:pf] && item[:pf] + 1.day >= pclass[index + 1][:pi]
              item[:pf] = pclass[index + 1][:pf]
            elsif item[:pf]  < pclass[index + 1][:pi]
              new_pclass << item
              item = {}
              item[:pi] = pclass[index + 1][:pi]
              item[:pf] = pclass[index + 1][:pf]
            end
            index += 1
          end
          item[:pf] = pclass[index][:pf] unless item.key?(:pf)
          new_pclass << item
          pedidos_user[user.cpf][situacao] = new_pclass
        end
      end
    end
    p pedidos_user
  end

  def pedidos
    # Obtém todos os pedidos da base, por usuário e
    # por STATUS_PEDIDO = ['pendente', 'disponível','concluído']
    users = User.all
    pu = {}
    # Todos os pedidos de acordo com o id do usuário
    users.each do |u|
      pu[u.id] = {} unless pu.key?(u.id)
      pedidos = Pedido.where(user_id: u.id)
      pedidos.each do |ped|
        pu[u.id][ped.situacao] = [] unless pu[u.id].key?(ped.situacao)
        pu[u.id][ped.situacao] << [ped.periodo_inicial, ped.periodo_final]
      end
    end
    # Todos os pedidos de acordo com o CPF do usuário
    todos_os_pedidos = {}
    users.each do |u|
      pu[u.id].each_key do |situacao|
        todos_os_pedidos[u.cpf] = {} unless todos_os_pedidos.key?(u.cpf)
        todos_os_pedidos[u.cpf][situacao] = [] unless todos_os_pedidos[u.cpf].key?(situacao)
        todos_os_pedidos[u.cpf][situacao] << pu[u.id][situacao]
      end
    end
    p todos_os_pedidos
  end

  def mesmos_no_repo
    repetidas = {}
    RepoNota.all.each do |nota|
      if !repetidas.key?(nota.numero_nota) && !RepoNota.where(numero_nota: nota.numero_nota).count == 1
        repetidas[nota.numero_nota] = []
        RepoNota.where(numero_nota: nota.numero_nota).each { |reponota| repetidas[nota.numero_nota] << reponota.nome_emitente }
      end
    end
    repetidas.each_key do |reponota|
      p "--> REPETIDAS: #{reponota.numero_nota}: -->/n"
      repetidas[reponota.numero_nota].each do |emitente|
        p "#{emitente.nome_emitente}"
      end
    end
  end

  def mesmas_notas
    repetidas = {}
    Nota.all.each do |nota|
      if !repetidas.key?(nota.numero_nota) && !Nota.where(numero_nota: nota.numero_nota).count == 1
        repetidas[nota.numero_nota] = []
        Nota.where(numero_nota: nota.numero_nota).each { |reponota| repetidas[nota.numero_nota] << reponota.nome_emitente }
      end
    end
    repetidas.each_key do |reponota|
      p "--> REPETIDAS: #{reponota.numero_nota}: -->/n"
      repetidas[reponota.numero_nota].each do |emitente|
        p "#{emitente.nome_emitente}"
      end
    end
  end

  def unknown
    # reponotas = XlsImporterAllBase.new("/home/rainey/code/PaxecoL/nfe-compra/db/Nota Fiscal cpf 0464.xlsx", 1)
    registers = xls_reader
    registers_stat = {}
    registers.each_key do |cpf|
      registers[cpf].each_key do |chave|
        qtt_items = registers[cpf][chave][:itens].length
        registers_stat[cpf] = [qtt_items, chave]
      end
    end

    items_to_save = 0
    keys_to_record = []
    registers_stat.sort_by{|_key,value| value}.reverse.each do |stat|
      if items_to_save < 1_000
        if stat[1][0] > 1
          keys_to_record << [stat[0],stat[1][1]]
          p "CPF: #{stat[0]} CHAVE: #{stat[1][1]} - Qtd itens: #{stat[1][0]}"
        end
        items_to_save += stat[1][0]
      else
        break
      end
    end
    keys_to_record.each do |cpf_chave|
      reponota = registers[cpf_chave[0]][cpf_chave[1]][:nota]
      reponota.save!
      registers[cpf_chave[0]][cpf_chave[1]][:itens].each do |repoitemnota|
        repoitemnota.repo_nota_id = reponota.id
        repoitemnota.save!
        # p "Chave #{reponota.chave} Descricao do Item #{repoitemnota.descricao}"
      end
    end
    puts "CPFs e chaves correspondentes com mais itens gravados"
    p keys_to_record[0..2]
    puts "CPFs com 2 itens (últimos gravados)"
    p keys_to_record[-2..-1]
  end

  private

  def xls_reader
    # NOT registers users
    notas_mercadorias = {}
    chaves = {}
    cpfs = {}
    nomes = {}
    x = Xsv::Workbook.open(@file_path)
    sheet = x.sheets[0]
    # Quantidade de linhas desconsideradas no nosso arquivo de 100_000 linhas
    # (cabeçalho, por exemplo, e considerando o máximo gratuito no Heroku: 1_000)
    # sheet.row_skip = 99_000
    sheet.row_skip = @lines_to_skip
    sheet.each_row do |row|
      # Dados da nota sem mercadorias (itens)
      nota = RepoNota.new
      nota.emissao = row[0]
      if nota.emissao.nil?
        break
      end
      nota.cpf_destinatario = row[1].gsub(/\D/, '')
      nota.nome_destinatario = row[2]
      unless cpfs.keys.include?(nota.cpf_destinatario)
        cpfs[nota.cpf_destinatario] = Faker::CPF.numeric
        nomes[nota.cpf_destinatario] = "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.last_name}"
      end
      nota.nome_destinatario = nomes[nota.cpf_destinatario]
      nota.cpf_destinatario = cpfs[nota.cpf_destinatario]
      nota.emitente = row[3]
      nota.nome_emitente = row[4]
      nota.descricao_cfop = row[5]
      nota.numero_nota = row[6].to_i
      chave_tmp = row[7]
      chave_original = chave_tmp.gsub(/\s/, '')
      # Embaralha os dígitos da chave se a nota não existir
      unless chaves.key?(chave_original)
        chave_simulada = chave_original.chars.shuffle.join
        chaves[chave_original] = chave_simulada
      end
      nota.chave = chaves[chave_original]
      notas_mercadorias[nota.cpf_destinatario] = {} unless notas_mercadorias.key?(nota.cpf_destinatario)
      unless notas_mercadorias[nota.cpf_destinatario].key?(chaves[chave_original])
        notas_mercadorias[nota.cpf_destinatario][chaves[chave_original]] = {}
        notas_mercadorias[nota.cpf_destinatario][chaves[chave_original]][:nota] = nota
        notas_mercadorias[nota.cpf_destinatario][chaves[chave_original]][:itens] = []
      end

      # Guarda os itens de uma determinada nota
      item = RepoItemNota.new
      # item.repo_nota = nota
      item.descricao = row[8]
      item.unidade_comercial = row[9]
      item.unidade_comercial = '-' if item.unidade_comercial.blank?
      item.quantidade_comercial = row[10]
      item.quantidade_comercial = item.quantidade_comercial.to_f
      item.quantidade_comercial = (item.quantidade_comercial * rand(1..3)).truncate(2)
      item.valor_unitario = row[11].to_f
      item.valor_unitario = (item.valor_unitario * rand(1.0..3.0)).truncate(2)
      item.valor_total = (item.valor_unitario * item.quantidade_comercial).truncate(2)
      # item.save!
      # Considera as mercadorias de uma nota
      notas_mercadorias[nota.cpf_destinatario][chaves[chave_original]][:itens] << item
    end
    return notas_mercadorias
  end
end
