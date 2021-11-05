class Nota < ApplicationRecord
  belongs_to :pedido
  has_many :items_notas
  validates :emissao, :cpf_destinatario, :emitente, :numero_nota, :chave, presence: true
  validates :cpf_destinatario, cpf: { message: 'CPF válido' }, length: { in: 11..14 }
  validates :chave, numericality: true, length: { is: 44 }, uniqueness: true
  validates :data_pedido, :data_resposta, :periodo_inicial, :periodo_final, inclusion: { in: (Date.today-2.years..Date.today) }
  validates :periodo_final inclusion: { in: :periodo_inicial..Date.today }
end
