class OrdersController < ApplicationController
  
  before_filter :load_stuffs
  before_filter :associate_customer_with_order, :only => [:index, :pickup, :delivery]
  before_filter :set_page_title
  
  before_filter :check_for_order_validity, :only => [:summary, :define_delivery_time, :submit_order]
  
  before_filter :test_printer_before_ordering, :only => [:submit_order]

  helper :orders

  include ActionView::Helpers::NumberHelper

  layout false, only: [:email_test]

  before_filter :freeze_time
  after_filter :unfreeze_time

  def freeze_time
    if !params[:freeze_time].blank?
      time = Time.parse(params[:freeze_time])
      Timecop.freeze(time)
    end
  end

  def unfreeze_time
    if params[:unfreeze_time]
      Timecop.return
    end
  end

  def create_deal
    @order = Order.find_by_id(session[:order_id])
    @product_combo = ProductCombo.find_by_slug(params[:slug])
    @slug = params[:slug]
    @pizza_category =  PizzaCategory.where(:active => true)
    if @product_combo.present? && @product_combo.no_of_pizza.to_i > 1
      if params[:deal_id].present?
        @deal_id = params[:deal_id]
      else 
        @deal_id = `#{@product_combo.try(:slug)}-#{rand 2500..999999}`
      end
      pizza_preset_ids = []
      if @product_combo.present?
        pizza_preset_ids = PizzaPreset.where(product_combo_id: @product_combo.id).map {|pp| pp.id}
      end
      item_count = @order.order_items.where(deal_id: @deal_id).count
      if item_count < @product_combo.no_of_pizza
        pizza_preset_ids.each_with_index do |pp, index|
          pizza_preset = PizzaPreset.find_by_id(pp)
          order_item = @order.order_items.create()
          order_item.product_info = pizza_preset.product_info
          order_item.deal_id = @deal_id
          order_item.pizza_position = index + 1
          order_item.save
        end
      end
      # setting seo metadata
      @seo_metadescription = @product_combo.seo_metadescription
      @seo_title = @product_combo.seo_title
      @seo_keywords = @product_combo.seo_keywords 
    else
      # for single pizza deals like delivery special, pickup special
      if params[:product_id].present?
        @order_item = @order.order_items.find_by_id(params[:product_id]) || @order.order_items.create()
      else
        @order_item = @order.order_items.create()
        if params[:pizza_preset_id] || params[:slug]
          if params[:slug].present?
            redirect_to orders_slug_deal_path(params.merge({ product_id: @order_item }))
          end
        end
      end 

      @pizza_preset = PizzaPreset.find_by_slug(params[:slug])
      @order_item.product_info = @pizza_preset.product_info
      @order_item.quantity = params[:quantity] if params[:quantity] && params[:quantity].to_i > 1
      @order_item.product_info["pizza_size"] = params[:pizza_size] if params[:pizza_size].present?
      @order_item.save
      if @pizza_preset && @pizza_preset.id === 90
        @order.update_attributes(for_pickup: true)
      end
      @pizza_size = PizzaSize.where(:name => @pizza_preset.product_info['pizza_size'].titleize).first
      # setting seo metadata
      @seo_metadescription = @pizza_preset.seo_metadescription
      @seo_title = @pizza_preset.seo_title
      @seo_keywords = @pizza_preset.seo_keywords 
    end
  end
  
  
  def index
    @pizza_category =  PizzaCategory.where(:active => true)

    @beverages.each do |beverage|
      puts beverage.name
    end

    if params[:pizza_preset_id] || params[:calzone_preset_id] || params[:slug] || params[:calzone_slug] || params[:deals_slug]
      
      # redirecting
      if params[:pizza_preset_id].present?
        pizza_preset = PizzaPreset.find_by_id(params[:pizza_preset_id])
        if pizza_preset.present?
          params.delete(:pizza_preset_id) if params[:pizza_preset_id].present?
          redirect_to orders_slug_path(params.merge({ slug: pizza_preset.try(:slug) })) and return
        else
          params.delete(:pizza_preset_id) if params[:pizza_preset_id].present?
          params.delete(:product_id) if params[:product_id].present?
          params.delete(:quantity) if params[:quantity].present?
          params.delete(:pizza_size) if params[:pizza_size].present?
          redirect_to '/orders/menu', status: 302 and return
        end
      end

      if params[:calzone_preset_id].present?
        calzone_preset = CalzonePreset.find_by_id(params[:calzone_preset_id])
        if calzone_preset.present?
          params.delete(:calzone_preset_id) if params[:calzone_preset_id].present?
          redirect_to orders_calzone_path(params.merge({ calzone_slug: calzone_preset.try(:slug) })) and return
        else
          params.delete(:calzone_preset) if params[:calzone_preset].present?
          params.delete(:product_id) if params[:product_id].present?
          redirect_to '/orders/menu', status: 302 and return
        end
      end
      
      # create new pizza from the preset

      @order = Order.find_by_id(session[:order_id])
      if params[:product_id].present?
        @order_item = @order.order_items.find_by_id(params[:product_id]) || @order.order_items.create()
      else
        @order_item = @order.order_items.create()
        if params[:pizza_preset_id] || params[:slug]
          if params[:slug].present?
            redirect_to orders_slug_path(params.merge({ product_id: @order_item }))
          else
            pizza_preset = PizzaPreset.find_by_id(params[:pizza_preset_id])
            redirect_to orders_slug_path(params.merge({ product_id: @order_item, slug: pizza_preset.try(:slug) }))
          end
        elsif params[:calzone_preset_id] || params[:calzone_slug]
          if params[:calzone_slug].present?
            redirect_to orders_calzone_path(params.merge({ product_id: @order_item }))
          else
            calzone_preset = CalzonePreset.find_by_id(params[:calzone_preset_id])
            redirect_to orders_calzone_path(params.merge({ product_id: @order_item, calzone_slug: calzone_preset.try(:slug) }))
          end
        elsif params[:deals_slug]
          redirect_to orders_deals_path(params.merge({ product_id: @order_item }))
        end
      end 
      
      # if @order.order_items.count === 0
        # @order_item = @order.order_items.create()
      # else 
      #   @order_item = @order.order_items.last
      # end

      if params[:pizza_preset_id] || params[:slug] || params[:deals_slug]
        puts "It's a pizza..."
        if params[:slug].present?
          @pizza_preset = PizzaPreset.find_by_slug(params[:slug])
        elsif params[:deals_slug].present?
          @pizza_preset = PizzaPreset.find_by_slug(params[:deals_slug])
        else
          @pizza_preset = PizzaPreset.find_by_id(params[:pizza_preset_id])
        end 
        puts @pizza_preset.to_xml 
        @order_item.product_info = @pizza_preset.product_info
        @order_item.quantity = params[:quantity] if params[:quantity] && params[:quantity].to_i > 1
        @order_item.product_info["pizza_size"] = params[:pizza_size] if params[:pizza_size].present?
        @order_item.save
        if @pizza_preset && @pizza_preset.id === 90
          @order.update_attributes(for_pickup: true)
        end
        @pizza_size = PizzaSize.where(:name => @pizza_preset.product_info['pizza_size'].titleize).first
      end
    
      if params[:calzone_preset_id] || params[:calzone_slug]
        puts "It's a calzone..."
        if params[:calzone_preset_id]
          @calzone_preset = CalzonePreset.find_by_id(params[:calzone_preset_id])
        else 
          @calzone_preset = CalzonePreset.find_by_slug(params[:calzone_slug])
        end
        @order_item.product_info = @calzone_preset.product_info
        @order_item.save
      end
      
    end

    # for seo meta data
    if @pizza_preset.present?
      @seo_metadescription = @pizza_preset.seo_metadescription
      @seo_title = @pizza_preset.seo_title
      @seo_keywords = @pizza_preset.seo_keywords 
    elsif @calzone_preset.present?
      @seo_metadescription = @calzone_preset.seo_metadescription
      @seo_title = @calzone_preset.seo_title
      @seo_keywords = @calzone_preset.seo_keywords 
    else
      # for menu page
      @seo_metadescription = "Pizzaiolo makes fresh pizza to order with fresh ingredients daily. A great menu of gourmet meat, veggie, vegan and Gluten-Free pizzas. Order online!"
      @seo_title = "Pizzaiolo | Toronto and GTA's Gourmet Pizzeria | Menu"
      @seo_keywords = "Pizzaiolo, Pizza, Gourmet Pizza, Calzones, Salads Pizzaiolo, Gourmet Pizza, Gluten Free, Menu, Pizza Menu" 
    end
    
  end

  def catering
    @pizza_category =  PizzaCategory.where(:active => true)
    # for seo meta data
    @seo_metadescription = "Make your event delicious with Pizzaiolo gourmet pizza catering options.  Options for every taste available for your events today!"
    @seo_title = "Pizzaiolo | Gourmet Pizza Catering | Delicious Events"
    @seo_keywords = "Pizzaiolo, Catering, Gourmet Pizza, Corporate Lunches, Takeout, Pizzaiolo Gourmet Pizza, Corporate Events, Events Catering" 
  end
  
  def details
    # create new pizza from the preset
    @order = Order.find_by_id(session[:order_id])
  end

  def complete_meal
    @order = Order.find_by_id(session[:order_id])
    @pizza_category =  PizzaCategory.where(:active => true)

    order_item_found = false

    # find and update quantity in existing order item
    if (params[:slug] || params[:pizza_preset_id]) && params[:quantity] && params[:quantity].to_i > 0
      @order.order_items.each do |item|
        if item.product_info['pizza_preset_id'].present?
          pizza_preset_id = ""
          if params[:pizza_preset_id].present?
            pizza_preset_id = params[:pizza_preset_id]
          elsif params[:slug].present?
            pizza_preset = PizzaPreset.find_by_slug(params[:slug])
            pizza_preset_id = pizza_preset.try(:id)
          end
          if item.product_info['pizza_preset_id'] == pizza_preset_id.try(:to_s)
            order_item_found = true
            item.quantity = params[:quantity].to_i
            item.product_info["pizza_size"] = params[:pizza_size] if params[:pizza_size].present?
            item.save
            if @show_cannoli_popup
              @pizza_preset = PizzaPreset.find_by_id(item.product_info['pizza_preset_id'])
              if @pizza_preset && @pizza_preset.product_info && @pizza_preset.product_info['product_type'] === 'pizza' && !@pizza_preset.is_product_combo && !@pizza_preset.is_10_inches && @order.order_additional
                @order.order_additional['cannolis']['cannoli_1'] += params[:quantity].to_i
                @order.save
              end
            end
          end
        end
      end

       # add order item in order
      if !order_item_found
        if params[:pizza_preset_id].present?
          @pizza_preset = PizzaPreset.find_by_id(params[:pizza_preset_id])
        else
          @pizza_preset = PizzaPreset.find_by_slug(params[:slug])
        end
        @order_item = @order.order_items.create()
        @order_item.product_info = @pizza_preset.product_info
        @order_item.quantity = params[:quantity] if params[:quantity] && params[:quantity].to_i > 0
        @order_item.product_info["pizza_size"] = params[:pizza_size] if params[:pizza_size].present?
        @order_item.save
        if @show_cannoli_popup
          if @pizza_preset && @pizza_preset.product_info && @pizza_preset.product_info['product_type'] === 'pizza' && !@pizza_preset.is_product_combo && !@order_item.is_catering && @order.order_additional
            @order.order_additional['cannolis']['cannoli_1'] = @order.order_additional['cannolis']['cannoli_1'].to_i + params[:quantity].to_i if params[:quantity] && params[:quantity].to_i > 0
            @order.save
          end
        end
      end
    end
    
  end

  def additional_items 
    @order = Order.find_by_id(session[:order_id])
    @pizza_categories = PizzaCategory.where(:active => true)
    @calzones = CalzonePreset.where(:active => true).order("product_name ASC")
    @pizza_presets = PizzaPreset.where(:active => true).order("product_name ASC")
    @salads = Salad.where(:active => true, :is_catering_product => false).order("name ASC")
    @salads_medium = Salad.where(:active => true, :is_catering_product => true, :salad_type => "MEDIUM").order("name ASC")
    @salads_large = Salad.where(:active => true, :is_catering_product => true, :salad_type => "LARGE").order("name ASC")
    @garlic_breads = GarlicBread.where(:active => true).order("name ASC")
    @dipping_sauces = DippingSauce.where(:active => true).order("position ASC")
    @desserts = Dessert.where(:active => true)
    @utensils = Utensil.where(:active => true)
    @beverages = Beverage.where(:active => true)
    @cannolis = Cannoli.where(:active => true)
  end
  
  def edit
    @order_item = OrderItem.find_by_id(params[:id])
  end
  
  
  def live_calculate_additional_items
    
    @order = Order.new
    @order.order_additional = params[:order][:order_additional]    
    respond_to do |format|
      format.js
    end
    # puts @order.beverages_total
    
  end


  def live_calculate_additional_for_combo_items

    @order = Order.find_by_id(session[:order_id])
   
    #params[:product][:id]
    #params[:order][:order_additional]
    if params[:product] && params[:product][:id]
      @order_item = OrderItem.find_by_id(params[:product][:id])
      if params[:product].present? && params[:product][:id].present? && (params[:product][:id].to_i === @order_item.id)
        @order_item.update_attributes(product_info: params[:product])
        #@order_item[:product_info][:combo_additional] = params[:order][:order_additional]
      else
        @order_item.product_info = params[:product]
      end
    else
      @order_item = OrderItem.new
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  
  def categories
    @pizza_category =  PizzaCategory.where(:active => true).find_by_slug(params[:slug])
    @pizza_presets = @pizza_category.pizza_presets.order("sort ASC, product_name ASC")

    # setting seo metadata
    if @pizza_category.present?
      @seo_metadescription = @pizza_category.seo_metadescription
      @seo_title = @pizza_category.seo_title
      @seo_keywords = @pizza_category.seo_keywords 
    end
  end
  
  
  def add_product
    puts session[:order_id]
    @order = Order.find_by_id(session[:order_id])
    
    # if the product exists, then update it, else add to the order
    
    if params[:product][:id]
      
      # update existing order item
      @oi = @order.order_items.find_by_id(params[:product][:id])
      @oi.update_attributes(:product_info => params[:product])
      
    else
      
      # create new order item
      @product = @order.order_items.create(:product_info => params[:product])
      
    end
    
    respond_to do |format|
      format.js
    end
    
  end
  
  # def show
  #   @order = Order.find_by_id(session[:order_id])
  #   if @order.nil?
  #     redirect_to "/orders/menu"
  #   end
  #   @order_item = OrderItem.where(:id => params[:id], :order_id => session[:order_id]).first
  # end
  
  def destroy
    @order = Order.find_by_id(session[:order_id])
    @order_item = OrderItem.where(:id => params[:id], :order_id => session[:order_id]).first
    if @order_item
      if @order_item.deal_id.present?
        @order.order_items.where(deal_id: @order_item.deal_id).destroy_all
      elsif @order_item.product_info["pizza_size"] === "10_inches" && @order_item.product_info["product_name"] != "Create Your Own Pizza" && @order_item.is_catering 
        if @order.order_additional && @order.order_additional["catering_pizza"] &&  @order.order_additional["catering_pizza"]["pizza_preset_id_#{@order_item.product_info["pizza_preset_id"]}"]
           @order.order_additional["catering_pizza"]["pizza_preset_id_#{@order_item.product_info["pizza_preset_id"]}"]["quantity"] = "0" 
        end
        @order_item.destroy
        @order.save
      else
        if @order.order_additional && @order.order_additional["catering_pizza"] &&  @order.order_additional["catering_pizza"]["pizza_preset_id_#{@order_item.product_info["pizza_preset_id"]}"]
          @order.order_additional["catering_pizza"]["pizza_preset_id_#{@order_item.product_info["pizza_preset_id"]}"]["quantity"] = "0" 
        end
        @order_item.destroy
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
          end
        end
        @order.save
      end
    end
    
    redirect_to details_path, :notice => "Product Deleted."    
    # respond_to do |format|
    #   format.js
    # end  
    
  end
  
  
  def add_additional_to_order
    @order = Order.find_by_id(session[:order_id])
    # find and update quantity in existing order item
    if params[:order][:order_additional][:catering_pizza] && params[:order][:order_additional][:catering_pizza].count > 0
      params[:order][:order_additional][:catering_pizza].each do |item|
        order_item_exist = false
        
        if item[1]['quantity'] && item[1]['pizza_preset_id'] && item[1]['quantity'].to_i > 0
          # add order item in caterign order
          @order.order_items.each do |oi|
            if oi.is_catering && oi.product_info["pizza_preset_id"] === item[1]['pizza_preset_id'].to_i
              oi.product_info["pizza_size"] = item[1]['pizza_size'] if item[1]['pizza_size'].present?
              oi.update_attributes(quantity: item[1]['quantity'].to_i)
              oi.save
              order_item_exist = true
            end
          end
          if !order_item_exist
            @pizza_preset = PizzaPreset.find_by_id(item[1]['pizza_preset_id'])
            @order_item = @order.order_items.create()
            @order_item.product_info = @pizza_preset.product_info
            @order_item.quantity = item[1]['quantity'] if item[1]['quantity'] && item[1]['quantity'].to_i > 0
            @order_item.is_catering = true
            @order_item.product_info["pizza_size"] = item[1]['pizza_size'] if item[1]['pizza_size'].present?
            @order_item.save
          end 
        else
          @order.order_items.each do |oi|
            if oi.is_catering && oi.product_info["pizza_preset_id"] === item[1]['pizza_preset_id'].to_i
              @order_item = OrderItem.where(:id => oi.id, :order_id => session[:order_id]).first
              if @order_item
                @order_item.destroy
              end
            end
          end
        end
      end
    end

    @order.update_attributes(params[:order])
  end
  
  
  # to remove salads, utensils, beverages, etc...
  def remove_additional
    @order = Order.find_by_id(session[:order_id])
    @order_additional = @order.order_additional
    @order_additional[params[:item_type]][params[:item]] = "0"
    @order.update_attributes(:order_additional => @order_additional)
    # @order.order_additional = @order_additional
    redirect_to details_path, :notice => "Product Deleted." 
  end
  
  def cancel_add_additional_to_order
    respond_to do |format|
      format.js
    end  
  end
  
  
  
  
  
  # delivery actions
  
  def delivery
    
    unless @order.total_price > 9.99
      redirect_to orders_path
      return false
    end
    
    if current_customer
      @customer = current_customer
      if @order.order_additional.blank? || @order.order_additional == 'null'
        puts "FFS"
        @order.update_attributes(:for_pickup => false, :order_additional => nil, :email => @customer.email, :first_name => @customer.first_name, :last_name => @customer.last_name, :address_1 => @customer.address_1, :address_2 => @customer.address_2, :city => @customer.city, :postal_code => @customer.postal_code, :phone_number => @customer.phone_number, :franchise_location_id => session[:franchise_location_id].to_i)
      else
        @order.update_attributes(:for_pickup => false, :email => @customer.email, :first_name => @customer.first_name, :last_name => @customer.last_name, :address_1 => @customer.address_1, :address_2 => @customer.address_2, :city => @customer.city, :postal_code => @customer.postal_code, :phone_number => @customer.phone_number, :franchise_location_id => session[:franchise_location_id].to_i)
      end
      redirect_to orders_delivery_address_path
    end
    
  end
  
  def pickup
    
    unless @order.total_price > 0
      redirect_to orders_path
      return false
    end
    
    if current_customer
      @customer = current_customer
      @order.update_attributes(:for_pickup => true, :email => @customer.email, :first_name => @customer.first_name, :last_name => @customer.last_name, :address_1 => @customer.address_1, :address_2 => @customer.address_2, :city => @customer.city, :postal_code => @customer.postal_code, :phone_number => @customer.phone_number, :franchise_location_id => session[:franchise_location_id].to_i)
      redirect_to orders_pickup_address_path
    end

  end
  
  
  
  
  
  
  def generate_customer

    puts params[:order]
    
    if params[:order] && params[:order][:goto_delivery] == "1"
      for_delivery = true
    else
      for_delivery = false
    end
    
    if params[:customer] && params[:customer][:create_account] == "1"
      create_account = true
    else
      create_account = false
    end

    if params[:customer] && params[:customer][:mailing_list] == "1"
      mailing_list = true
    else
      mailing_list = false
    end
    
    puts "Delivery: #{for_delivery}"
    puts "Create Account: #{create_account}"
  
    
    if create_account == true
      
      # UPDATE THE ORDER AND GENERATE A NEW CUSTOMER ACCOUNT
      
      @customer = Customer.new(params[:order])
      
      @check = Customer.where(:email => params[:order][:email]).first
      if @check
        account_exists = true
      else
        account_exists = false
      end
      
      if @customer.save
        
        @customer.update_attributes(:mailing_list => mailing_list)
        
        sign_in(:customer, @customer)
        
        if for_delivery
          # define the contact info
          params['order']['for_pickup'] = false
          @order.update_attributes(params[:order])
          redirect_to orders_delivery_path, :notice => "Your account has been created, you are now signed in."
        else
          # define the contact info
          params['order']['for_pickup'] = true
          @order.update_attributes(params[:order])
          redirect_to orders_pickup_path, :notice => "Your account has been created, you are now signed in."
        end
        
      else
        
        if for_delivery
          if account_exists == true
            flash[:error] = "An account already exists with that email address."
          else
            flash[:error] = "There was a problem creating your account, please verify your details."
          end
          redirect_to orders_delivery_path
        else
          if account_exists == true
            flash[:error] = "An account already exists with that email address."
          else
            flash[:error] = "There was a problem creating your account, please verify your details."
          end
          redirect_to orders_pickup_path
        end
        
      end
      
    else
      
      # UPDATE THE ORDER
      if for_delivery
        params['order']['for_pickup'] = false
        @order.update_attributes(params[:order])
        redirect_to orders_delivery_address_path, :notice => "Your information has been saved."
      else
        params['order']['for_pickup'] = true
        @order.update_attributes(params[:order])
        redirect_to orders_pickup_address_path, :notice => "Your information has been saved."
      end
      
      
    end
    
    
  end
  
  
  def update_order_with_delivery_address

    # test the delivery address and make sure it is deliverable
    
    # check the address is deliverable...
    # myloc = Geocoder.coordinates(params[:order][:delivery_postal_code].downcase)

    address = [params[:order][:delivery_address_1], params[:order][:delivery_city], params[:order][:delivery_postal_code]].compact.join(", ")
    myloc = ApplicationController.helpers.geo_code(params[:order][:delivery_postal_code], address) if params[:order] && params[:order][:delivery_postal_code]
    
    if myloc
      
      @fl = FranchiseLocation.where(:active => true, :order_online => true)
      
      @fl.each do |l|
        if l.location_in_area(myloc[1],myloc[0])
          @locations = FranchiseLocation.where(:active => true, :order_online => true, :id => l.id)
          puts "This is the delivery ID: #{l.id}"
          # session[:franchise_location_id] = l.id
        end
      end
      
      if @locations
        
        puts "THERE IS A LOCATION..."
        
        session[:franchise_location_id] = @locations.first.id
        params['order']['franchise_location_id'] = session[:franchise_location_id]
        # params['order']['delivery_address_1'] = params['order']['address_1']
        # params['order']['delivery_address_2'] = params['order']['address_2']
        # params['order']['delivery_city'] = params['order']['city']
        # params['order']['delivery_postal_code'] = params['order']['postal_code']
        
        if @order.update_attributes(params[:order])
          redirect_to orders_define_delivery_time_path, :notice => "The delivery address has been added to your order info."
        else
          flash[:error] = "There was an error updating the address."
          redirect_to orders_update_order_with_delivery_address_path
        end
        
      else
        flash[:error] = "The delivery address you entered is not within a Pizzaiolo Delivery area."
        # redirect_to orders_update_order_with_pickup_address_path
        render :delivery_address
      end
      
    else
      
      flash[:error] = "There was an error updating your contact info."
      # redirect_to orders_update_order_with_pickup_address_path
      render :delivery_address
      
    end
    
        # 
    # 
    # 
    # 
    # 
    # params['order']['franchise_location_id'] = session[:franchise_location_id]
    # if @order.update_attributes(params[:order])
    #   redirect_to orders_define_delivery_time_path, :notice => "Address info saved."
    # else
    #   flash[:notice] = "There was an error updating the address."
    #   redirect_to orders_update_order_with_delivery_address_path
    # end
    
  end
  
  def update_order_with_pickup_address
    params['order']['franchise_location_id'] = session[:franchise_location_id] if params['order']
    if @order.update_attributes(params[:order])
      redirect_to orders_choose_pickup_location_path, :notice => "Address info saved."
    else
      flash[:notice] = "There was an error updating your contact info."
      redirect_to orders_update_order_with_pickup_address_path
    end
  end
  
  
  
  
  def delivery_address
    
    if current_customer
      
      # use the customer profile info to choose delivery address from...
      
      
      
    else
      
      if @order.delivery_address_1.blank?
        
        # NOT filled in yet, prep form with the data from the order contact info...
        
        @order.delivery_address_1 = @order.address_1
        
      else
        
        # HAS been filled in, allow the customer to edit the delivery details if required.
        
        
        
      end
        
      
    end
    
  end
  
  def pickup_address
    
    
    
  end
  
  
  
  def add_delivery_address
    
    puts params[:address]
    
    address_id = false
    
    # save new address, if applicable.
    if params['address'] && params['address']['save_new'] && params['address']['save_new'] == "1"
      @address = current_customer.addresses.new(params[:address])
      address_id = @address.id
    end
    
    if params['address']['address_id']
      address_id = params['address']['address_id'].to_i
    end
    
    
    # check the address is deliverable...
    # myloc = Geocoder.coordinates(params[:address][:postal_code].downcase)
    address = [params[:address][:address_1], params[:address][:city], params[:address][:postal_code]].compact.join(", ")
    myloc = ApplicationController.helpers.geo_code(params[:address][:postal_code], address)
    
    puts myloc
    
    if myloc
      
      puts "postal code recognized, find the order location..."
      
      @fl = FranchiseLocation.where(:active => true, :order_online => true)
      
      if myloc
        @fl.each do |l|
          if l.location_in_area(myloc[1],myloc[0])
            @locations = FranchiseLocation.where(:active => true, :order_online => true, :id => l.id)
            puts "This is the delivery ID: #{l.id}"
            # session[:franchise_location_id] = l.id
          end
        end
      end
      
      if @locations
        
        puts "this is a deliverable location, make sure that the session variable is set correctly..."
        
        puts session[:franchise_location_id]
        puts @locations.first.id
        
        if @locations.first.id != session[:franchise_location_id]
          puts "the pizzaiolo location is different, alert user on next screen"
          # notice = "Your delivery information has been saved and the nearest pizzaiolo location for this location has changed."
        else
          puts "the pizzaiolo location is the same, advance to the next screen..."
        end
        
        session[:franchise_location_id] = @locations.first.id
        
        if address_id == false
          # save without an associated address
          @order.update_attributes(:delivery_address_1 => params[:address][:address_1], :delivery_address_2 => params[:address][:address_2], :delivery_city => params[:address][:city], :delivery_postal_code => params[:address][:postal_code], :address_id => nil, :franchise_location_id => session[:franchise_location_id])
        else
          # save with am associated address
          @order.update_attributes(:delivery_address_1 => params[:address][:address_1], :delivery_address_2 => params[:address][:address_2], :delivery_city => params[:address][:city], :delivery_postal_code => params[:address][:postal_code], :address_id => address_id, :franchise_location_id => session[:franchise_location_id])
        end
        
        if @address
          @address.save
        end

        redirect_to orders_define_delivery_time_path, :notice => "Your delivery information has been saved."
        
      else
        puts "the location is not deliverable, show the form again... "
        flash[:error] = "<strong>The postal code entered is outside of the Pizzaiolo delivery area</strong>.<br />Please enter a different postal code and try again."
        render :delivery_address
        flash[:error] = nil
      end
    else
      puts "postal code not recognized, bounce back to conifrm"
      flash[:error] = "The postal code entered was not found, please verify and try again."
      render :delivery_address
      flash[:error] = nil
    end  
  end
  
  def add_pickup_address
    
    # save new address, if applicable...
    if params['address']['phone_number'] && params['address']['save_new'] == "1"
      @contact_phone_number = current_customer.contact_phone_numbers.new(params[:address])
      @contact_phone_number.save
    end
    @order.update_attributes(:contact_phone_number => params[:address][:phone_number])
    # redirect_to orders_define_delivery_time_path, :notice => "Your pickup information has been saved."
    redirect_to orders_choose_pickup_location_path
  end
  
  
  def define_delivery_time
    if params[:overtime] == '1'
      flash[:error] = "<strong>Your order has timed out.</strong><br />To make sure your order is deliverable, please select or update the order time below."
    end
    
  end
  
  
  
  def get_delivery_times
    @year = params[:order_time][:year]
    @month = params[:order_time][:month]
    @day = params[:order_time][:day]
    @time = params[:order_time][:time]
    
    # can the delivery time be met?
    
    time = Time.parse("#{@year}-#{@month}-#{@day} #{@time}")
    puts "this is the time: #{time}"
    
    puts "This is a #{time.strftime("%A")}"
    
    if @order.for_pickup?
      for_pickup = true
    else
      for_pickup = false
    end
    
    # puts @order.order_additional['catering_order']
    
    if time > Time.now + 30.days
      @message = "<p class='text-error'>Orders can only be placed up to 30 days from now.</p>"
    else
      if !@order.order_additional.blank? && @order.order_additional != "" && @order.order_additional != "null" && @order.order_additional['catering_order'].present? && @order.order_additional['catering_order'] == "1" && time < (Time.now + 3.hours)
        @message = "<p class='text-error'>Catering Orders require 3 hours before being ready for pickup or delivery. Please select another date/time.</p>"
        puts "This is a catering order"
      else
        close_day = "#{time.strftime("%a").try(:downcase)}_full_day_close"
        if time.hour < FranchiseLocation::CUTOFF_HOUR_FOR_LATE_NIGHT_LOCATIONS
          close_day = "#{(time - 1.day).strftime("%a").try(:downcase)}_full_day_close"
        else
          close_day = "#{(time).strftime("%a").try(:downcase)}_full_day_close"
        end
        if @order.franchise_location.send(close_day)
          @message = "<p class='text-error'>Please select another order day. Location is CLOSED</p>"
          puts "The time you selected cannot be delivered. Please select a different day"
        else
          if @order.franchise_location.can_be_ready_at_this_datetime(time,for_pickup) == true
            puts "Can be ordered"
            @message = "<p class='text-success'>This order can be delivered or picked up at this time and date.</p>"
          else
            @message = "<p class='text-error'>Please select another order time.</p>"
            puts "The time you selected cannot be delivered. Please select a different time/day"
          end
        end
      end
    end
    
  end
  
  def check_delivery_times_and_goto_summary
    
    @year = params[:order_time][:year]
    @month = params[:order_time][:month]
    @day = params[:order_time][:day]
    @time = params[:order_time][:time]
    
    @goto_summary = false
    
    # can the delivery time be met?
    
    time = Time.parse("#{@year}-#{@month}-#{@day} #{@time}")
    puts "this is the time: #{time}"
    
    puts "This is a #{time.strftime("%A")}"
    
    if @order.for_pickup?
      for_pickup = true
    else
      for_pickup = false
    end
    
    if time > Time.now + 30.days
      @message = "<p class='text-error'>Orders can only be placed up to 30 days from now.</p>"
    else
      if !@order.order_additional.blank? && @order.order_additional != "" && @order.order_additional != "null" && @order.order_additional['catering_order'].present? && @order.order_additional['catering_order'] == "1" && time < (Time.now + 3.hours)
        @message = "<p class='text-error'>Catering Orders require 3 hours before being ready for pickup or delivery. Please select another date/time.</p>"
        puts "This is a catering order"
      else
        if @order.franchise_location.can_be_ready_at_this_datetime(time,for_pickup) == true
          puts "Can be ordered"
          @message = "<p class='text-success'>This order can be delivered or picked up at this time and date.</p>"
          @goto_summary = true
        else
          @message = "<p class='text-error'>Please select another order time.</p>"
          puts "The time you selected cannot be delivered. Please select a different time/day"
        end
      end
    end

    @order.update_attributes(:is_asap => false)
    
  end
  
  
  def set_delivery_time
    
    day = params["order_time"]['date(3i)'].to_s
    month = params["order_time"]['date(2i)'].to_s
    year = params["order_time"]['date(1i)'].to_s
    time = params["order_time"]['time(5i)'].to_s
    
    time = Time.parse("#{year}-#{month}-#{day} #{time}")
    
    puts "Time for delivery requested: #{time}"
    
    if @order.for_pickup?
      for_pickup = true
    else
      for_pickup = false
    end
    
    if time > Time.now + 30.days
      
      flash[:error] = "This order cannot be placed more than 30 days in the future."
      redirect_to orders_define_delivery_time_path
      
    else
      
      if @order.franchise_location.can_be_ready_at_this_datetime(time, for_pickup) == true
        
        # save the datetime in the order...
        @order.update_attributes(:to_be_ready_at => time)
        redirect_to orders_summary_path
        
      else
        flash[:error] = "This order cannot be placed at the time requested, please select another time."
        redirect_to orders_define_delivery_time_path
      end  
    end
    
  end

  # apply discount code on order if valid
  def apply_discount_code
    is_valid = false
    error_message = ""
    
    discount_code = DiscountCode.find_by_code(params[:discount_code].try(:strip))
    
    if discount_code.present? && discount_code.active && discount_code.value.to_f > 0.0
      if @order.total_price > 0
        discount_applied = @order.apply_discount(discount_code)
        if discount_applied
          is_valid = true
          error_message = ""
        else
          is_valid = false
          error_message = "Discount code is not valid for items in you cart."
        end
      else
        is_valid = false
        error_message = "Cart value must be greater then $10 to apply discount code."
      end
    else
      is_valid = false
      error_message = "Discount code is invalid or it has expired. Please try another discount code."
    end

    render json: { 
      is_valid: is_valid,
      discount_dollar_value: "-$#{@order.discount_dollar_value}",
      total: number_to_currency(@order.total_price_including_sales_tax_inc_delivery.round(2)),
      discount_code: params[:discount_code].try(:strip),
      error_message: error_message
    }
  end

  # remove discount code from order
  def remove_discount_code
    @order.update_attributes(discount_promo_code: nil, discount_code_id: nil, discount_dollar_value: 0.0)
    
    render json: { 
      is_removed: true,
      discount_dollar_value: '-$0.0',
      total: number_to_currency(@order.total_price_including_sales_tax_inc_delivery.round(2)),
      discount_code: params[:discount_code].try(:strip),
      error_message: "Problem in removing discound code."
    }
  end

  def order_asap_check
    is_asap = true
    if @order.for_pickup?
      time_asap = @order.franchise_location.try(:pickup_asap_eta)
    else
      time_asap = @order.franchise_location.try(:deliver_asap_eta)
    end

    if TimeDifference.between(time_asap, Time.now).in_seconds > 1.hours
      display_popup = true
      is_asap = false
    else
      display_popup = false
      is_asap = true
    end

    @order.update_attributes(:to_be_ready_at => time_asap, :is_asap => is_asap) if time_asap

    render json: { 
      date: time_asap.strftime('%b %d, %Y %I:%M%p'),
      display_popup: display_popup
    }

  end
  
  def order_asap
    if @order.for_pickup?
      time_asap = @order.franchise_location.try(:pickup_asap_eta)
    else
      time_asap = @order.franchise_location.try(:deliver_asap_eta)
    end
    @order.update_attributes(:to_be_ready_at => time_asap) if time_asap
    redirect_to orders_summary_path    
  end
  
  
  def define_pickup_time
    
    
    
  end
  
  
  
  
  
  
  def choose_pickup_location
    # find order to get info 
    @order = Order.find_by_id(session[:order_id])
    @locations = FranchiseLocation.where(:active => true, :order_online => true)
    
    
    if params[:find_location_near_me].blank? || params[:find_location_near_me] == ""
      
      @locations = FranchiseLocation.where(:active => true, :order_online => true)
      
    else
      
      # myloc = Geocoder.coordinates(params[:find_location_near_me].downcase)
      myloc = ApplicationController.helpers.geo_code(params[:find_location_near_me])
      
      
      # based on distance, not on the delivery area...
      
      @locations = FranchiseLocation.where(:active => true, :order_online => true).near(myloc, 10)
      
      session[:postal_code] = params[:find_location_near_me].upcase
      puts session[:postal_code]
      
      
    end

    @all_active_locations = FranchiseLocation.where(:active => true)
    if (params[:find_location_near_me].blank? || params[:find_location_near_me] == "") && params[:find_location_in_area].blank?
      @locations = FranchiseLocation.where(:active => true)
    else
      @locations = @all_active_locations
      if !params[:find_location_near_me].blank?
        myloc = ApplicationController.helpers.geo_code(params[:find_location_near_me])
        @locations = @locations.near(myloc, 10)
      end
      if !params[:find_location_in_area].blank?
        @locations = @locations.where(area_name: params[:find_location_in_area])
      end
    end
    @all_areas = [["Show All", ""]] + @all_active_locations.map(&:area_name).uniq.map{|x| [x, x] }
    
    
  end
  
  
  def set_pickup_location
    
    @order = Order.find_by_id(session[:order_id])
    @franchise_location = FranchiseLocation.find_by_id(params[:id])
    
    if @order.update_attributes(:franchise_location_id => @franchise_location.id)
      redirect_to orders_define_delivery_time_path, :notice => "Your pickup location has been saved."
    else
      flash[:notice] = "The pickup location could not be saved."
      redirect_to orders_update_order_with_delivery_address_path
    end
    
  end
  
  
  
  def submit_order
    if @order.for_pickup
      closing_time = @order.franchise_location.closed_for_pickup_datetime
    else
      closing_time = @order.franchise_location.closed_for_delivery_datetime
    end

    if @order.is_asap
      # order is asap
      if Time.now < closing_time.try(:to_datetime)
        order_can_be_placed = true
      else
        order_can_be_placed = false
        error_message = "We're sorry, order cannot be accepted as the store is now closed."
      end 
    else
      # order is scheduled order
      if @order.franchise_location.can_be_ready_at_this_datetime(@order.to_be_ready_at, @order.for_pickup)
        order_can_be_placed = true
      else
        order_can_be_placed = false
        error_message = "The time you have selected cannot be used for delivery. Please select a different date or time."
      end
    end

    if order_can_be_placed
      if @order.for_pickup == false
        unless params[:order].present? && params[:order][:method_of_payment_id].present?
          redirect_to orders_summary_path, :notice => "Please select a method of payment."
          return false
        end
      end
      error = false
      error_msg = ""
      unless @order.ordered?
        
        # if @order.for_pickup == false
          @order.update_attributes(:ordered => true, :method_of_payment_id => params[:order][:method_of_payment_id], :special_instructions => params[:order][:special_instructions], :ordered_at => Time.now)
        # else
        #   @order.update_attributes(:ordered => true, :special_instructions => params[:order][:special_instructions], :ordered_at => Time.now)
        # end
        
        # # detect if the application is running on stage or not
        # unless request.host == "stage.pizzaiolo.ca"
        #   @order.print_and_confirm_order
        # else
        #   # send email to customer only to test result
        #   @order.email_confirmation_to_customer
        #   puts "Only testing customer email."
        # end

        if params[:order][:method_of_payment_id] === "4" && @order.franchise_location.try(:enable_online_payments)
          if @order.franchise_location.try(:bambora_env) === 'production'
            Beanstream.merchant_id = @order.franchise_location.try(:bambora_pro_merchant_id)
            Beanstream.payments_api_key = @order.franchise_location.try(:bambora_pro_api_key)
          else
            Beanstream.merchant_id = @order.franchise_location.try(:bambora_dev_merchant_id)
            Beanstream.payments_api_key = @order.franchise_location.try(:bambora_dev_api_key)
          end
          begin
            ActiveRecord::Base.transaction do
              response = Beanstream.PaymentsAPI.make_payment(
                {
                  :order_number => @order.try(:order_number),
                  :amount => @order.try(:total_price_including_sales_tax_inc_delivery),
                  :payment_method => Beanstream::PaymentMethods::TOKEN,
                  :token => {
                    :name => [@order.first_name, @order.last_name].compact.join(' '),
                    :code => params[:order][:token],
                    :complete => true
                  },
                  :billing => {
                    :name => params[:order][:name],
                    :email_address => params[:order][:email],
                    :address_line1 => params[:order][:address_line1],
                    :address_line2 => params[:order][:address_line2],
                    :city => params[:order][:city],
                    :province => params[:order][:provice] || "ON",
                    :postal_code => params[:order][:postal_code],
                    :country => params[:order][:country] || "CA",
                    :phone_number => params[:order][:phone_number],
                  }
                }
              )
              payment = PaymentTransaction.create(
                amount: response['amount'],
                last_four_digits: response['card']['last_four'],
                transaction_id: response['order_number'],
                status: 'success',
                order_id: @order.id,
                franchise_location_id: @order.franchise_location.id,
                transaction_date: response['created'],
                card_type: response['card']['card_type'],
                remarks: response['message'],
                first_name: params[:order][:first_name],
                last_name: params[:order][:last_name],
                postal_code: params[:order][:postal_code],
                address_1: params[:order][:address_line1],
                address_2: params[:order][:address_line2],
                email: params[:order][:email],
                phone_number: params[:order][:phone_number],
                city: params[:order][:city],
                province: params[:order][:province],
                country: params[:order][:country],
                discount_code: @order.try(:discount_code),
                discount_code_id: @order.try(:discount_code_id),
                discount_dollar_value: @order.try(:discount_dollar_value)
              )
              @order.print_and_confirm_order
            end
          rescue Beanstream::BeanstreamException => ex
            error = true
            puts "Exception: #{ex.user_facing_message}"
            payment = PaymentTransaction.create(
              amount: 0.0,
              status: 'error',
              transaction_date: Time.now,
              order_id: @order.id,
              franchise_location_id: @order.franchise_location.id,
              remarks: ex.to_json,
              first_name: params[:order][:first_name],
              last_name: params[:order][:last_name],
              postal_code: params[:order][:postal_code],
              address_1: params[:order][:address_line1],
              address_2: params[:order][:address_line2],
              email: params[:order][:email],
              phone_number: params[:order][:phone_number],
              city: params[:order][:city],
              province: params[:order][:province],
              country: params[:order][:country]
            )
            @order.update_attributes(:ordered => false)
            error_msg = ex.user_facing_message
          end
        else
          @order.print_and_confirm_order
        end
      end
      
      
      if !error
        session[:ordered_id] = @order.id
        # create new order for this session and/or customer
        if current_customer
          @new_order = current_customer.orders.new()
          @new_order.save
          session[:order_id] = @new_order.id
        else
          @new_order = Order.new
          @new_order.save
          session[:order_id] = @new_order.id
        end
      else 
        session[:order_id] = @order.id
      end
    else 
      session[:order_id] = @order.id
    end
         
    if error
      OrderMailer.order_online_payment_fails_email(@order.id).deliver
      flash[:error] = "<strong>We're sorry, transaction failed: #{error_msg} Please make sure you have entered correct payment and billing information."
      redirect_to orders_summary_path
    elsif !order_can_be_placed
      flash[:error] = "<strong>We're sorry, but the order cannot be placed at this time. Please try again later."
      redirect_to orders_summary_path
    else
      redirect_to orders_thankyou_path
    end
    
  end

  def set_percentage_tip
    @order = Order.find_by_id(params[:id])
    if @order.present? && params[:percentage].present?
      if  params[:tip_type] == "percentage"
        tip_amount = @order.percentage_tip_amount(params[:percentage])
      else 
        tip_amount = params[:tip_amount] || 0
      end
      @order.update_attributes(:tip_type => params[:tip_type], :tip_percentage => params[:percentage], :tip_amount => tip_amount)
      render json: {
        tip_amount: number_to_currency(tip_amount),
        order_total: @order.for_pickup ? number_to_currency(@order.total_price_including_sales_tax_inc_tip) : number_to_currency(@order.total_price_including_sales_tax_inc_delivery_and_tip)
      }
    else
      render json: {
        tip_amount: number_to_currency(0.0), 
        order_total: @order.for_pickup ? number_to_currency(@order.total_price_including_sales_tax_inc_delivery) : number_to_currency(@order.total_price_including_sales_tax_inc_delivery)
      }
    end
  end

  def clear_tip
    @order = Order.find_by_id(params[:id])
    if @order.present?
      @order.update_attributes(:tip_type => "", :tip_percentage => 0, :tip_amount => 0)
      render json: {
        tip_amount: number_to_currency(0.0),
        order_total: @order.for_pickup ? number_to_currency(@order.total_price_including_sales_tax_inc_tip) : number_to_currency(@order.total_price_including_sales_tax_inc_delivery_and_tip)
      }
    else 
      render json: {
        tip_amount: number_to_currency(0.0),
        order_total: number_to_currency(0.0)
      }
    end
    
  end

  def thankyou
    @order = Order.find_by_id(session[:ordered_id])
    if @order.nil?
      redirect_to "/orders/menu"
    else
      @delivery_pickup_message = ""
      
      # For delivery/pickup message
      if @order.for_pickup
        @delivery_pickup_message = "You can pickup your order on #{@order.to_be_ready_at.strftime(DATE_ONLY_FORMAT)} at approximately #{@order.to_be_ready_at.strftime(TIME_ONLY_FORMAT)}"
      else
        @delivery_pickup_message = "Your order will be delivered on #{@order.to_be_ready_at.strftime(DATE_ONLY_FORMAT)} at approximately #{@order.baked_items_count >= 3 && @order.is_asap ? (@order.to_be_ready_at - 10.minutes).strftime(TIME_ONLY_FORMAT) + ' - ' + (@order.to_be_ready_at).strftime(TIME_ONLY_FORMAT) : @order.to_be_ready_at.strftime(TIME_ONLY_FORMAT) }"
        @delivery_pickup_message += "<br /><i>Delivery time is approximate and does not factor in peak order volume times, weather and traffic conditions.</i>"
        @delivery_pickup_message = @delivery_pickup_message.html_safe
      end
      @total_price = @order.total_price_including_sales_tax_inc_delivery.round(2)
      puts "total_price: #{@total_price}" 
      # puts @order.to_xml
    end
  end

  def summary
    
    can_be_ready_in_time = true
    @store_close_message = ""

    if @order.for_pickup?
      if Time.now + FRANCHISE_LOCATION_PICKUP_OFFSET - 1.minutes > @order.to_be_ready_at
        can_be_ready_in_time = false
      end

      if Time.now.between?((@order.franchise_location.closed_for_pickup_datetime - 10.minutes), @order.franchise_location.closed_for_pickup_datetime)
        @store_close_message = "The store is closing within #{TimeDifference.between(Time.now, @order.franchise_location.closed_for_pickup_datetime - 10.minutes).in_minutes.round} minutes, orders must be placed before the store closes."
      end
    else
      if Time.now + FRANCHISE_LOCATION_DELIVERY_OFFSET - 1.minutes > @order.to_be_ready_at
        can_be_ready_in_time = false
      end
      if Time.now.between?((@order.franchise_location.closed_for_delivery_datetime - 10.minutes), @order.franchise_location.closed_for_delivery_datetime)
        @store_close_message = "The store is closing within #{TimeDifference.between(Time.now, @order.franchise_location.closed_for_delivery_datetime - 10.minutes).in_minutes.round} minutes, orders must be placed before the store closes."
      end
    end
    # if @order.pickup_special?
    #   @order.order_items.each do |order_item|
    #     if order_item.pickup_special?
          
    #     end
    #   end
    # else

    # end
    if params[:overtime] == "1"
      can_be_ready_in_time = false
    end
    
    unless can_be_ready_in_time == true
      flash[:error] = "<strong>Your order has timed out.</strong><br />To make sure your order is deliverable, please select or update the order time below."
      redirect_to orders_define_delivery_time_path
    end

    # setting 15% default tip if online payments enabled on store
    if @order.franchise_location.try(:enable_online_payments)
      @order.update_attributes(:tip_type => "percentage", :tip_percentage => 15, :tip_amount => @order.percentage_tip_amount('15'), :method_of_payment_id => 4)
    end
    
  end

  
  def add_item_from_menu
    
    if params[:product_type] == "pizza"
      @pizza_preset = PizzaPreset.find_by_id(params[:id])
      if @pizza_preset
        OrderItem.create(:product_info => @pizza_preset.product_info, :order_id => @order.id)
      end
      redirect_to orders_path, :notice => "The pizza has been added to your order."
    end
    
    if params[:product_type] == "calzone"
      @calzone_preset = CalzonePreset.find(params[:id])
      if @calzone_preset
        OrderItem.create(:product_info => @calzone_preset.product_info, :order_id => @order.id)
      end
      redirect_to orders_path, :notice => "The calzone has been added to your order."
    end
    
  end
  
  def print_order
    if Rails.env.production?
      # printer = Rescpos::Printer.open("192.168.0.38", 9100)
      printer = Rescpos::Printer.open("192.168.2.29", 9100) 
      report = PrintTestReport.new
      printer.print_report(report, :encoding => "UTF-8//IGNORE")
      printer.close
    end
  end
  
  
  def test_printer_before_ordering
    return true if ENV['DO_NOT_CHECK_PRINTER'] == "true"
    begin
      timeout(1) do
        
        if Rails.env.production?
          printer = Rescpos::Printer.open(@order.franchise_location.printer_ip.to_s, @order.franchise_location.printer_port.to_i)
          printer.close
        end
      
        # if Rails.env.development?

        #   printer = Rescpos::Printer.open("192.168.2.29", 9100)
        #   printer.close
        # end
        
      end
      
    rescue
      flash[:error] = "<strong>We're sorry, there was a problem contacting your selected Pizzaiolo Location</strong><br />Please update your #{ if @order.for_pickup? then "pickup time" else "delivery time" end } to try again.<br />Or you can call: <strong>#{@order.franchise_location.phone}</strong> to order over the phone."
      redirect_to orders_define_delivery_time_path
      return
    end
    
  end
    
  def check_for_order_validity
    if @order.franchise_location_id.blank? || @order.first_name.blank?
      redirect_to orders_path
      return false
    end
  end

  # For pre-fill customer detail in bambora payment form
  def get_customer_details 
    @order = Order.find_by_id(params[:id])
    if @order.present?
      render json: {
        name: [@order.first_name, @order.last_name].compact.join(" "),
        email: @order.email,
        city: @order.city,
        postal_code: @order.postal_code,
        address_1: @order.address_1,
        phone_number: @order.phone_number
      }
    else
      render json: {message: "Order not found"}, status: 404
    end 
  end 

  def update_order_additional_quantity_details
    @order = Order.find_by_id(params[:id])
    if @order.present?

      if params[:quantity] && params[:quantity].to_i > 0 && params[:order_additional_id] && params[:order_additional]
        order_additional_name = params[:order_additional]
        order_additional_id = params[:order_additional_id]
        @order.order_additional[order_additional_name][order_additional_id] = params[:quantity]
        if @order.save
          respond_to do |format|
            format.html {render partial: "orders/shopping_cart_table"}
          end
        else
          render json: {message: "Unable to update order additional item"}, status: 402
        end
      else
        render json: {message: "Order additional item not found"}, status: 404
      end

    else
      render json: {message: "Order not found"}, status: 404
    end 
  end

  def update_deal_quantity
    @order = Order.find_by_id(params[:id])
    
    if @order.present? && params[:deal_id] && params[:quantity] && params[:quantity].to_i > 0
      @order.order_items.where(deal_id: params[:deal_id]).update_all(quantity: params[:quantity])
    end

    respond_to do |format|
      format.html {render partial: "orders/shopping_cart_table"}
    end
  end
  
  private
  
    def load_stuffs
      # orders
      if session[:order_id].blank?
        @order = Order.new
        @order.order_additional = @order.empty_order_additional
        @order.save
        session[:order_id] = @order.id
      else
        @order = Order.find_by_id(session[:order_id])
        if @order.nil?
          @order = Order.new
          @order.order_additional = @order.empty_order_additional
          @order.save
          session[:order_id] = @order.id
        elsif @order.order_additional.nil?
          @order.order_additional = @order.empty_order_additional
          @order.save
        end
      end
      
      @pizza_categories = PizzaCategory.where(:active => true)
      @calzones = CalzonePreset.where(:active => true).order("product_name ASC")
      @pizza_presets = PizzaPreset.where(:active => true, :is_10_inches=> false).order("product_name ASC")
      @pizza_presets_10inches = PizzaPreset.where(:active => true, :is_10_inches=> true).order("category_id ASC, product_name ASC")
      @salads = Salad.where(:active => true, :is_catering_product => false).order("name ASC")
      @salads_medium = Salad.where(:active => true, :is_catering_product => true, :salad_type => "MEDIUM").order("name ASC")
      @salads_large = Salad.where(:active => true, :is_catering_product => true, :salad_type => "LARGE").order("name ASC")
      @garlic_breads = GarlicBread.where(:active => true).order("name ASC")
      @dipping_sauces = DippingSauce.where(:active => true).order("sort_order_for_combos ASC")
      @desserts = Dessert.where(:active => true)
      @utensils = Utensil.where(:active => true)
      @beverages = Beverage.where(:active => true).order("sort_order_for_combos ASC")
      @cannolis = Cannoli.where(:active => true)
      @show_cannoli_popup = false
    end
    
    
    
    def associate_customer_with_order
      if current_customer
        if @order.customer_id != current_customer.id
          @order.update_attributes(:customer_id => current_customer.id)
        end
      else
        if @order.customer_id != nil
          @order.update_attributes(:customer_id => nil)
        end
      end
    end
    
    def set_page_title
      content_for :title, "Order Online"
      @heading = "order_online"
      @header = "order_online"
    end

    def specials
      @order = Order.find_by_id(session[:order_id])
    end
    

    def email_preview
      @order = Order.find_by_id(333)
    end
    
    def email_test
      puts "tESTING TESTING tESTING TESTING tESTING TESTING tESTING TESTING tESTING TESTING "
      @order = Order.find_by_id(333)
    end

end