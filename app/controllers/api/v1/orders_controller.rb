class Api::V1::OrdersController < Api::V1::BaseController

  def show
    @order = current_store.orders.find(params[:id])
    render json: @order.order_attributes_for_pos
  end

  def acknowledge
    @order = current_store.orders.find(params[:id])
    if @order.acknowledged_by_pos_at
      render json: {
        error: "order already acknowledged"
      }, status: 422  
    else
      if params[:acknowledged_by_pos_at]
        @order.acknowledged_by_pos_at = params[:acknowledged_by_pos_at]
        if @order.save
          render json: @order.order_attributes_for_pos
        else
          render json: {
            error: "error updating the record"
          }, status: 422  
        end
      else
        render json: {
          error: "please specify acknowledged_by_pos_at, it must be a string in this format: 2019-10-09T11:31:38-04:00"
        }, status: 422
      end
    end
  end

end