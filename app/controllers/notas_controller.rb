class NotasController < ApplicationController
  # before_action :authenticate_user!
  def index
    @notas = Nota.where(cpf_destinatario: current_user.cpf)
    @totais = totalizar(@notas);
    puts "TOTAIS: #{@totais}"
  end

  private

  def totalizar(notas)
    @total = {}
    notas.each_with_index do |nota, index|
      itens = ItemNota.where(nota: nota)
      @total[nota.id] = itens.sum(&:valor_total)
    end
    @total
  end
end
