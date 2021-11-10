


# # /home/mariocfbais/code/MarioCesarBais/nfe-compra/tmp/Nota Fiscal cpf 0464.xlsx
#   # Registers Users
#     # @chave = 1000000000
#     # @chaves = {}
#     # @users = User.all
#     # x = Xsv::Workbook.open(@file_path)
#     # sheet = x.sheets[0]
#     # sheet.row_skip = 1
#     # sheet.each_row do |row|
#     #   # Dados da nota sem mercadorias (itens)
#     #   nota = RepoNota.new
#     #   nota.emissao = row[0]
#     #   if nota.emissao.nil?
#     #     break
#     #   end
#     #   nota.cpf_destinatario = row[1].gsub(/\D/, '')
#     #   @user_now = @users[rand(0...@users.length)]
#     #   nota.nome_destinatario = row[2]
#     #   nota.emitente = row[3]
#     #   nota.nome_emitente = row[4]
#     #   nota.descricao_cfop = row[5]
#     #   nota.numero_nota = row[6].to_i
#     #   chave_tmp = row[7]
#     #   nota.chave = chave_tmp.gsub(/\s/, '')
#     #   if @chaves.keys.include?(nota.chave)
#     #     nota = RepoNota.where("chave = '#{@chaves[nota.chave]}'")[0]
#     #   else
#     #     nota.cpf_destinatario = @user_now.cpf
#     #     nota.nome_destinatario = @user_now.name
#     #     @chave += 10
#     #     @chave_simulada = @chave.to_s.rjust(44, "0")
#     #     @chaves[nota.chave] = @chave_simulada
#     #     nota.chave = @chave_simulada
#     #     nota.save!
#     #   end
#     #   # Dados das mercadorias (itens da NFe)
#     #   item = RepoItemNota.new
#     #   item.repo_nota = nota
#     #   item.descricao = row[8]
#     #   item.unidade_comercial = row[9]
#     #   item.quantidade_comercial = row[10]
#     #   item.quantidade_comercial = item.quantidade_comercial.to_f
#     #   item.quantidade_comercial = (item.quantidade_comercial * rand(1..3)).truncate(2)
#     #   item.valor_unitario = row[11].to_f
#     #   item.valor_unitario = (item.valor_unitario * rand(1.0..3.0)).truncate(2)
#     #   item.valor_total = (item.valor_unitario * item.quantidade_comercial).truncate(2)
#     #   item.save!
#     # end

#     # NOT registers users
#     # "/home/rainey/code/PaxecoL/nfe-compra/tmp/Nota Fiscal cpf xxxx.xlsx"
#     @file_path = "db/Nota Fiscal cpf 0464.xlsx"
#     @chave = 0
#     @chaves = {}
#     cpfs = {}
#     nomes = {}
#     x = Xsv::Workbook.open(@file_path)
#     sheet = x.sheets[0]
#     sheet.row_skip = 1
#     sheet.each_row do |row|
#       # Dados da nota sem mercadorias (itens)
#       nota = RepoNota.new
#       nota.emissao = row[0]
#       if nota.emissao.nil?
#         break
#       end
#       nota.cpf_destinatario = row[1].gsub(/\D/, '')
#       nota.nome_destinatario = row[2]
#       # Faker::Name.first_name       #=> "Kaci"
#       # Faker::Name.middle_name      #=> "Abraham"
#       # Faker::Name.last_name        #=> "Ernser"
#       if cpfs.keys.include?(nota.cpf_destinatario)
#         nota.nome_destinatario = nomes[nota.cpf_destinatario]
#         nota.cpf_destinatario = cpfs[nota.cpf_destinatario]
#       else
#         cpfs[nota.cpf_destinatario] = Faker::CPF.numeric
#         nomes[nota.cpf_destinatario] = "#{Faker::Name.first_name} #{Faker::Name.middle_name} #{Faker::Name.last_name}"
#         nota.nome_destinatario = nomes[nota.cpf_destinatario]
#         nota.cpf_destinatario = cpfs[nota.cpf_destinatario]
#       end
#       nota.emitente = row[3]
#       nota.nome_emitente = row[4]
#       nota.descricao_cfop = row[5]
#       nota.numero_nota = row[6].to_i
#       chave_tmp = row[7]
#       nota.chave = chave_tmp.gsub(/\s/, '')
#       if @chaves.keys.include?(nota.chave)
#         nota = RepoNota.where("chave = '#{@chaves[nota.chave]}'")[0]
#       else
#         @chave += 10
#         @chave_simulada = @chave.to_s.rjust(44, "0")
#         @chaves[nota.chave] = @chave_simulada
#         nota.chave = @chave_simulada
#         nota.save!
#       end
#       # Dados das mercadorias (itens da NFe)
#       item = RepoItemNota.new
#       item.repo_nota = nota
#       item.descricao = row[8]
#       item.unidade_comercial = row[9]
#       item.unidade_comercial = '-' if item.unidade_comercial.blank?
#       item.quantidade_comercial = row[10]
#       item.quantidade_comercial = item.quantidade_comercial.to_f
#       item.quantidade_comercial = (item.quantidade_comercial * rand(1..3)).truncate(2)
#       item.valor_unitario = row[11].to_f
#       item.valor_unitario = (item.valor_unitario * rand(1.0..3.0)).truncate(2)
#       item.valor_total = (item.valor_unitario * item.quantidade_comercial).truncate(2)
#       item.save!
#     end
@cpfs = RepoNota.select(:cpf_destinatario).distinct
10.times {
  @user = User.new
  @user.email = Faker::Internet.email
  @user.password = '123456'
  @cpf = @cpfs.sample
  @user.cpf = @cpf.cpf_destinatario
  @cpfs.where(cpf_destinatario: @cpf.cpf_destinatario).destroy_all
  @user.name = Faker::Name.name
  @user.save!
}
puts 'criados 10 Users novos'
User.all.each { |user|
  rand(3..10).times {
    @pedido = Pedido.new
    @pedido.user_id = user.id
    @pedido.periodo_inicial = rand(Date.civil(2020, 1, 1)..Date.today)
    @pedido.periodo_final = rand(@pedido.periodo_inicial..Date.today)
    @pedido.data_pedido = rand(@pedido.periodo_final..Date.today)
    @pedido.situacao = 'pendente'
    @pedido.data_resposta = nil
    @pedido.save
  }
}
puts 'criados pedidos'

Pedido.all.each { |pedido|
  @cpf = User.find(pedido.user_id).cpf
  @reponotas = RepoNota.where(cpf_destinatario: @cpf)
  @reponotas.each { |reponota|
    reponota = reponota.attributes
    reponota['pedido_id'] = pedido.id
    id_reponota = reponota['id']
    reponota.delete('id')
    @nota = Nota.create(reponota)
    @repo_items = RepoItemNota.where(repo_nota_id: id_reponota)
    @repo_items.each { |repo_item|
      repo_item = repo_item.attributes
      repo_item['nota_id'] = @nota.id #repo_item['repo_nota_id']
      repo_item.delete('repo_nota_id')
      repo_item.delete('id')
      ItemNota.create!(repo_item)
    }
  }
}
puts "Concluídas Notas e Itens"
