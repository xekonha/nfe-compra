class CreatePortugueses < ActiveRecord::Migration[6.0]
  def change
    create_table :portugueses do |t|
      t.string :locale
      t.string :key
      t.text :value
      t.text :interpolations
      t.boolean :is_proc, default: false

      t.timestamps
    end
  end
end
