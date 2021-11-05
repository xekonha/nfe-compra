# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_05_105053) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_nota", force: :cascade do |t|
    t.bigint "nota_id", null: false
    t.string "descricao"
    t.string "unidade_comercial"
    t.decimal "quantidade_comercial"
    t.decimal "valor_unitario"
    t.decimal "valor_total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["nota_id"], name: "index_item_nota_on_nota_id"
  end

  create_table "nota", force: :cascade do |t|
    t.bigint "pedido_id", null: false
    t.date "emissao"
    t.string "cpf_destinatario"
    t.string "nome_destinatario"
    t.string "emitente"
    t.string "nome_emitente"
    t.string "descricao_cfop"
    t.integer "numero_nota"
    t.string "chave"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["pedido_id"], name: "index_nota_on_pedido_id"
  end

  create_table "pedidos", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "periodo_inicial"
    t.date "periodo_final"
    t.datetime "data_pedido"
    t.string "situacao"
    t.datetime "data_resposta"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_pedidos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cpf"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "item_nota", "nota", column: "nota_id"
  add_foreign_key "nota", "pedidos"
  add_foreign_key "pedidos", "users"
end
