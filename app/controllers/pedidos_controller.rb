class PedidosController < ApplicationController

  def index
    @pedido = Pedido.new
    @pedidos = Pedido.where(user: current_user).order("data_pedido ASC")
  end

  def create
    @pedido = Pedido.new(pedido_params)
    @pedido.data_pedido = DateTime.now
    @pedido.situacao = "Pendente"
    @pedido.user = current_user
    if @pedido.save
      redirect_to pedidos_path, notice: "Solicitação de #{@pedido.periodo_inicial} a #{@pedido.periodo_final}
      efetuada com sucesso. Em até 24 horas você receberá uma notificação por email com o link para o resultado."
    else
      render :index
    end
  end

  private

  def pedido_params
    params.require(:pedido).permit(:periodo_inicial, :periodo_final)
  end
end
