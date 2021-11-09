class RepoNota < ApplicationRecord
  has_many :repo_item_notas
  validates :emissao, :cpf_destinatario, :emitente, :numero_nota, :chave, presence: true
  validates :cpf_destinatario, length: { in: 11..14 }
  validates :chave, numericality: true, length: { is: 44 }
end
