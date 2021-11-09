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

ActiveRecord::Schema.define(version: 2021_11_05_201413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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

  create_table "repo_item_nota", force: :cascade do |t|
    t.bigint "repo_nota_id", null: false
    t.string "descricao"
    t.string "unidade_comercial"
    t.decimal "quantidade_comercial"
    t.decimal "valor_unitario"
    t.decimal "valor_total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["repo_nota_id"], name: "index_repo_item_nota_on_repo_nota_id"
  end

  create_table "repo_nota", force: :cascade do |t|
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "item_nota", "nota", column: "nota_id"
  add_foreign_key "nota", "pedidos"
  add_foreign_key "pedidos", "users"
  add_foreign_key "repo_item_nota", "repo_nota", column: "repo_nota_id"
end
