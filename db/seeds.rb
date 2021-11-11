# # Inicializa 1.000 Reponotas (sheet.row_skip = 99000)
xls = XlsImporterAllBase.new("db/Nota Fiscal cpf 0464.xlsx")
xls.unknown

@cpfs = RepoNota.select(:cpf_destinatario).distinct
# A partir das Reponotas cria os usuarios, pedidos e notas
10.times {
  @user = User.new
  @user.email = Faker::Internet.email
  @user.password = '123456'
  @cpf = @cpfs.sample.cpf_destinatario
  @user.cpf = @cpf
  @cpfs.where(cpf_destinatario: @cpf).destroy_all
  @user.name = Faker::Name.name
  @user.save!
}
puts 'Criados 10 Users novos'

User.all.each { |user|
  rand(3..10).times {
    @pedido = Pedido.new
    @pedido.user_id = user.id
    @pedido.periodo_inicial = rand(Date.civil(2021, 1, 1)..Date.today)
    @pedido.periodo_final = rand(@pedido.periodo_inicial..Date.today)
    @pedido.data_pedido = rand(@pedido.periodo_final..Date.today)
    @pedido.situacao = 'pendente'
    @pedido.save
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
