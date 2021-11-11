class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :pedidos
  has_many :notas, through: :pedidos
  # has_many :items_notas, through: :notas # descomentar esta linha caso deseje filtrar
  # itens por CPF, sem procurar notas vinculadas a CPF
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :cpf, uniqueness: true, cpf: true
  validates :email, presence: true, email: true

end
