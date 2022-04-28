class OrderItemsController < ApplicationController
  # before_filter :set_page_title, :only => [:edit]
  before_filter :load_stuffs
  
  def edit
   
    if params[:id]
      
      @order = Order.find_by_id(session[:order_id])
      @order_item = Order.find_by_id(session[:order_id]).order_items.find_by_id(params[:id])
      
      if @order_item.present?

        if @order_item.product_info['product_type'] == 'calzone'
          @calzone_preset = CalzonePreset.find_by_id(@order_item.product_info['calzone_preset_id'])
        end
        
        if @order_item.product_info['product_type'] == 'pizza'
          @pizza_preset = PizzaPreset.find_by_id(@order_item.product_info['pizza_preset_id'])
          @pizza_size = PizzaSize.where(:name => @order_item.product_info['pizza_size'].titleize).first
        end
      else
        redirect_to orders_path
      end
        
    end
   
    @pizza_categories = PizzaCategory.where(:active => true)
    @calzones = CalzonePreset.where(:active => true).order("product_name ASC")
    @salads = Salad.where(:active => true, :is_catering_product => false).order("name ASC")
    @salads_medium = Salad.where(:active => true, :is_catering_product => true, :salad_type => "MEDIUM").order("name ASC")
    @salads_large = Salad.where(:active => true, :is_catering_product => true, :salad_type => "LARGE").order("name ASC")
    @garlic_breads = GarlicBread.where(:active => true).order("name ASC")
    @dipping_sauces = DippingSauce.where(:active => true).order("name ASC")
    @desserts = Dessert.where(:active => true)
    @utensils = Utensil.where(:active => true)
    @beverages = Beverage.where(:active => true).order("name ASC")
    # respond_to do |format|
    #   format.js
    # end
    
  end
  
  
  
  def add_or_update
    
    puts "adding or updating..."
    
    @order = Order.find_by_id(session[:order_id])
    
    # if the product exists, then update it, else add to the order
    
    if params[:product] && params[:product][:id]
      
      # update existing order item
      @oi = @order.order_items.find(params[:product][:id])
      @oi.update_attributes(:product_info => params[:product])
      
    else
      
      # create new order item
      @oi = @product = @order.order_items.create(:product_info => params[:product])
      
    end

    if @show_cannoli_popup
      qty = 0
      @order.order_items.where(deal_id: nil, is_catering: false).each do |oi|
        if oi.product_info && oi.product_info['product_type'] === 'pizza' && !["Delivery Special", "Pickup Special"].include?(oi.product_info['product_name'])
          qty = qty + oi.quantity.to_i
        end
      end
      # hard code for now
      if @order.order_additional && @order.order_additional["cannolis"] && @order.order_additional["cannolis"].count > 0
        @order.order_additional["cannolis"]["cannoli_1"] = qty
        @order.save
      end
    end

    respond_to do |format|
      format.js
    end
    
  end

  def pizza_size_prices
    @order_item = OrderItem.new

    size_prices = {}

    if params[:product]
      PizzaSize.where(active: true).each do |pizza_size|
        size_name = pizza_size.name.downcase.gsub(" ", "_")
        params[:product][:pizza_size] = size_name
        @order_item.product_info = params[:product]
        size_prices[size_name] = @order_item.price.to_f
      end
    end
    
    render json: size_prices.to_json
  end
  
  
  def live_calculate
    @order_item = OrderItem.new
    @order_item.product_info = params[:product]
    @order_item.deal_id = params[:product][:deal_id] if params[:product].present? && params[:product][:deal_id].present?
    @order_item.pizza_position = params[:product][:pizza_position] if params[:product].present? && params[:product][:pizza_position].present?
    puts "The calculated price for this item is: #{@order_item.price}"
    
    respond_to do |format|
      format.js
    end
    
  end

  def deal_live_calculate
    if params[:product][:id].present?
      @order_item = OrderItem.find_by_id(params[:product][:id])
      @order_item.product_info = params[:product]
      @order_item.save
    else
      @order_item = OrderItem.new
      @order_item.product_info = params[:product]
      @order_item.deal_id = params[:product][:deal_id] if params[:product].present? && params[:product][:deal_id].present?
      @order_item.pizza_position = params[:product][:pizza_position] if params[:product].present? && params[:product][:pizza_position].present?
    end

    @order = @order_item.order
    @deal_id = @order_item.deal_id
    puts "The calculated price for this item is: #{@order_item.price}"
    
    respond_to do |format|
      format.js
    end
    
  end
  
  

  
  def new
    # create new pizza from the preset
    @order = Order.find_by_id(session[:order_id])
    @order_item = OrderItem.new

    if params[:pizza_preset_id]
      puts "It's a pizza..."
      @pizza_preset = PizzaPreset.find_by_id(params[:pizza_preset_id])
      puts @pizza_preset.to_xml
      @order_item.product_info = @pizza_preset.product_info
      @pizza_size = PizzaSize.where(:name => @pizza_preset.product_info['pizza_size'].titleize).first
    end
    
    if params[:calzone_preset_id]
      puts "It's a calzone..."
      @calzone_preset = CalzonePreset.find_by_id(params[:calzone_preset_id])
      @order_item.product_info = @calzone_preset.product_info
    end
    
    # puts @order_item.to_xml
    
    respond_to do |format|
      format.js
    end
    
  end

  
  def destroy

    @order = Order.find_by_id(session[:order_id])
    @order_item = OrderItem.where(:id => params[:id], :order_id => session[:order_id]).first
    @order_item.destroy

    # redirect_to orders_path, :notice => "Product Deleted."
    
    respond_to do |format|
      format.js
    end
    
  end

  def update_quantity
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item && params[:quantity] && params[:quantity].to_i > 0
      @order_item.update_attributes(quantity: params[:quantity]) 
    end

    respond_to do |format|
      format.html {render partial: "order_items/inline_calculator"}
    end

  end


  def update_quantity_details
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item && params[:quantity] && params[:quantity].to_i > 0
      @order_item.update_attributes(quantity: params[:quantity]) 
    end

    if @show_cannoli_popup
      qty = 0
      @order.order_items.where(deal_id: nil, is_catering: false).each do |oi|
        if oi.product_info && oi.product_info['product_type'] === 'pizza' && !["Delivery Special", "Pickup Special"].include?(oi.product_info['product_name'])
          qty = qty + oi.quantity.to_i
        end
      end
      # hard code for now
      if @order.order_additional && @order.order_additional["cannolis"] && @order.order_additional["cannolis"].count > 0
        @order.order_additional["cannolis"]["cannoli_1"] = qty
        @order.save
      end
    end

    respond_to do |format|
      format.html {render partial: "orders/shopping_cart_table"}
    end

  end

  def change_pizza_size_details
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item && params[:size]
      @order_item.product_info['pizza_size'] = params[:size].parameterize
      @order_item.save
    end

    respond_to do |format|
      format.html {render partial: "orders/shopping_cart_table"}
    end

  end

  private

    def load_stuffs
      @show_cannoli_popup = false
    end

  # def set_page_title
  #   content_for :title, "Order Online"
  #   @heading = "order_online"
  #   @header = "order_online"
  # end
  
  
end
