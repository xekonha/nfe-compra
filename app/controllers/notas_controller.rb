class NotasController < ApplicationController
  def index
    @notas = Notas.where("cpf_destinatario = 'current_user'")
  end

  # def periodo
  #   @notas_periodo = Notas.where(cpf_destinatario = current_user).and(emissao >= periodo_inicial).and(emissao <= periodo_final) # período inicial e final informados no view index
  # end
end
