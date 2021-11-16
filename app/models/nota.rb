class Nota < ApplicationRecord
  belongs_to :pedido
  has_many :item_notas
  validates :emissao, :cpf_destinatario, :emitente, :numero_nota, :chave, presence: true
  validates :cpf_destinatario, length: { in: 11..14 }
  validates :chave, numericality: true, length: { is: 44 }, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search_by_supplier_items, against: :nome_emitente,
    associated_against: {
      item_notas: :descricao
    }
end
