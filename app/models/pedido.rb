class Pedido < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :user
  has_many :notas
  has_many :items_notas, through: :notas
  validates :periodo_inicial, :periodo_final, :data_pedido, :situacao, presence: true
  validates_with DatesValidator
end
