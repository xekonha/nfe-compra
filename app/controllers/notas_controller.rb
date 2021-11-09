class NotasController < ApplicationController
  def index
    @notas = Notas.where("cpf_destinatario = 'current_user'")
  end
end
