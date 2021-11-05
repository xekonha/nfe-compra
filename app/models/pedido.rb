class Pedido < ApplicationRecord
  belongs_to :user
  has_many :notas
  has_many :items_notas, through: :notas
  validates :periodo_inicial, :periodo_final, :data_pedido, :situacao, presence: true
end
