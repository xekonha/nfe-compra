
# Inicializa nossos 4 Users com emails aleatorios e 4 Pedidos
simple_xls = XlsImporter.new("NFEs.xlsx")
simple_xls.import

# # Inicializa 1.000 Reponotas (sheet.row_skip = 99000)
full_xls = XlsImporterAllBase.new("db/Nota Fiscal cpf 0464.xlsx")
full_xls.import

# A partir das Reponotas cria os usuarios, pedidos e notas
10.times {
  @user = User.new
  @user.email = Faker::Internet.email
  @user.password = '123456'
  @user.cpf = Faker::CPF.numeric
  @user.name = Faker::Name.name
  @user.save!
}
puts 'Criados 10 Users novos'
@cpfs = RepoNota.select(:cpf_destinatario).distinct
User.all.each { |user|
  rand(3..10).times {
    @pedido = Pedido.new
    @pedido.user_id = user.id
    @pedido.periodo_inicial = rand(Date.civil(2021, 1, 1)..Date.today)
    @pedido.periodo_final = rand(@pedido.periodo_inicial..Date.today)
    @pedido.data_pedido = rand(@pedido.periodo_final..Date.today)
    @pedido.situacao = 'pendente'
    @pedido.save
    RepoNota.where(cpf_destinatario: @cpfs.sample.cpf_destinatario).update_all(cpf_destinatario: user.cpf)
  }
}
puts 'criados pedidos'

Pedido.all.each { |pedido|
  @reponotas = RepoNota.where(cpf_destinatario: pedido.user.cpf)
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
