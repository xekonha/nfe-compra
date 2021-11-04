class CreatePedidos < ActiveRecord::Migration[6.0]
  def change
    create_table :pedidos do |t|
      t.references :user, null: false, foreign_key: true
      t.date :periodo_inicial
      t.date :periodo_final
      t.datetime :data_pedido
      t.string :situacao
      t.datetime :data_resposta

      t.timestamps
    end
  end
end
