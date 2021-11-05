class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :pedidos
  has_many :notas, through: :pedidos
  # has_many :items_notas, through: :notas # descomentar esta linha caso deseje filtrar
  # itens por CPF, sem procurar notas vinculadas a CPF
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates_format_of :email,
  :with => /\b(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\b/i

  # https://www.campuscode.com.br/conteudos/codigo-ruby-para-calculo-de-validacao-de-cpf
  validates :cpf, length: { in: 11..14 }, uniqueness: true
end
