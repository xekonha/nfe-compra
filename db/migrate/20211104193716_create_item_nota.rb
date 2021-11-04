class CreateItemNota < ActiveRecord::Migration[6.0]
  def change
    create_table :item_nota do |t|
      t.references :nota, null: false, foreign_key: true
      t.string :descricao
      t.string :unidade_comercial
      t.decimal :quantidade_comercial
      t.decimal :valor_unitario
      t.decimal :valor_total

      t.timestamps
    end
  end
end
