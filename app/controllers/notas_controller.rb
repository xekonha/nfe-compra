class NotasController < ApplicationController
  # before_action :authenticate_user!
  def index
    @notas = Nota.where(cpf_destinatario: current_user.cpf) # .and(restingir período)
  end
end
