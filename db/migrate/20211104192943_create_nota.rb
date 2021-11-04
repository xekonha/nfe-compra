class CreateNota < ActiveRecord::Migration[6.0]
  def change
    create_table :nota do |t|
      t.references :pedido, null: false, foreign_key: true
      t.date :emissao
      t.string :cpf_destinatario
      t.string :nome_destinatario
      t.string :emitente
      t.string :nome_emitente
      t.string :descricao_cfop
      t.integer :numero_nota
      t.string :chave

      t.timestamps
    end
  end
end
