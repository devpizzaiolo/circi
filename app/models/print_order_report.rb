class PrintOrderReport < Rescpos::Report

  require 'rescpos'
  attr_accessor :order
  
  def initialize(id)
    @order = Order.find(id)
  end
  
  
end