class RepoItemNota < ApplicationRecord
  belongs_to :repo_nota
  validates :descricao, :unidade_comercial, :quantidade_comercial, :valor_unitario, :valor_total, presence: true
  validates :quantidade_comercial, :valor_unitario, :valor_total, numericality: true
end
