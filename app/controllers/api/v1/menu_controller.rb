class Api::V1::MenuController < Api::V1::BaseController

  def index
    products = []
    products += PizzaPreset.all.map{|pp| {id: pp.id, name: pp.product_name, product_type: "pizza", active: pp.active } }
    products += Beverage.all.map{|pp| {id: pp.id, name: pp.name, product_type: "beverage", active: pp.active } }
    products += Salad.all.map{|pp| {id: pp.id, name: pp.name, product_type: "salad", active: pp.active } }
    products += DippingSauce.all.map{|pp| {id: pp.id, name: pp.name, product_type: "dipping_sauce", active: pp.active } }
    products += GarlicBread.all.map{|pp| {id: pp.id, name: pp.name, product_type: "garlic_bread", active: pp.active } }
    products += CalzonePreset.all.map{|pp| {id: pp.id, name: pp.product_name, product_type: "calzone", active: pp.active } }
    render json: products.to_json
  end
end