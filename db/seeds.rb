# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# 10.times {
#   @user = User.new
#   @user.email = Faker::Internet.email
#   @user.password = '123456'
#   @user.cpf = Faker::CPF.numeric
#   @user.name = Faker::Name.name
#   @user.save!
# }
# puts 'criados 10 Users novos'
# User.all.each { |user|
#   rand(3..10).times {
#     @pedido = Pedido.new
#     @pedido.user_id = user.id
#     @pedido.periodo_inicial = rand(Date.civil(2020, 1, 1)..Date.today)
#     @pedido.periodo_final = rand(@pedido.periodo_inicial..Date.today)
#     @pedido.data_pedido = rand(@pedido.periodo_final..Date.today)
#     @pedido.situacao = 'pendente'
#     @pedido.data_resposta = nil
#     @pedido.save!
#   }
# }
# puts 'criados pedidos'

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
