class NotasController < ApplicationController
  def index
    @notas = Nota.where(cpf_destinatario: current_user.cpf)
    if params[:query].present?
      @notas = Nota.search_by_supplier_items(params[:query])
    end
    @totais = totalizar(@notas);
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
