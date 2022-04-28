class Order < ActiveRecord::Base  
  include ActionView::Helpers
  
  belongs_to :customer
  belongs_to :franchise_location
  belongs_to :method_of_payment
  belongs_to :discount_code

  scope :ordered, -> { where(ordered: true) }
  scope :today, -> { where(ordered_at: (Time.now.beginning_of_day)..(Time.now.end_of_day)) }
  scope :yesterday, -> { where(ordered_at: (Date.yesterday.beginning_of_day)..(Date.yesterday.end_of_day)) }
  
  # belongs_to :contact_phone_number
  
  has_many :order_items, dependent: :destroy
  has_many :payment_transactions
  
  attr_accessible :customer_id, :special_instructions, :order_additional, :tip_type, :tip_percentage, :tip_amount
  
  attr_accessible :delivery_address_1, :delivery_address_2, :delivery_city, :delivery_first_name, :delivery_last_name, :delivery_mailing_list, :delivery_phone_number, :delivery_postal_code, :contact_phone_number
  attr_accessible :address_1, :address_2, :city, :first_name, :last_name, :mailing_list, :phone_number, :postal_code, :phone_number, :email, :for_pickup, :password, :password_confirmation, :goto_delivery, :address_id, :is_asap
  attr_accessible :franchise_location_id, :to_be_ready_at, :ordered, :ordered_at, :payment_method, :goto_pickup, :contact_phone_number_id, :created_at, :updated_at, :special_instructions, :method_of_payment_id, :sent_to_printer, :email_sent
  attr_accessible :discount_promo_code, :discount_code_id, :discount_dollar_value
  
  # fro signing up a user via the contact info portion of the order process
  attr_accessor :password, :password_confirmation, :goto_delivery, :goto_pickup, :save_new
  
  
  serialize :order_additional, JSON
  
  
  after_update :remove_null
  

  def deal_price(deal_id)
    price = 0.0
    self.order_items.where(deal_id: deal_id).each do |oi|
      price += oi.price.to_f
    end
    if self.order_items.where(deal_id: deal_id).count > 0
      pizza_preset_id = self.order_items.where(deal_id: deal_id).first.product_info['pizza_preset_id']
      pizza_preset = PizzaPreset.find_by_id(pizza_preset_id)
      product_combo = ProductCombo.find_by_id(pizza_preset.product_combo_id)
      if price.to_f < product_combo.combo_base_price.to_f
        price = product_combo.combo_base_price
      end
    end
    price.to_f
  end

  def deal_edit_path(deal_id)
    pizza_preset_id = self.order_items.where(deal_id: deal_id).first.product_info['pizza_preset_id']
    pizza_preset = PizzaPreset.find_by_id(pizza_preset_id)
    product_combo = ProductCombo.find_by_id(pizza_preset.product_combo_id)
    return "/orders/deals/#{product_combo.try(:slug)}?deal_id=#{deal_id}"
  end

  def cart_item_counter
    count = 0
    without_deal_item_count = self.order_items.where(deal_id: nil).count
    
    count += without_deal_item_count if without_deal_item_count > 0

    with_deal_item_count = self.order_items.where("deal_id IS NOT NULL").group_by(&:deal_id).count

    count += with_deal_item_count if with_deal_item_count > 0

    count
  end
  
  # test check in on new GIT repos
  # additional methods
  
  def total_price
    
    total_price = 0
    
    # CALZONES & PIZZAS
    self.order_items.each do |oi|
      total_price += oi.try(:price).to_f * oi.quantity.to_i
    end
    
    # ADDITIONAL ITEMS
    
    dipping_sauces_total = 0
    salads_total = 0
    desserts_total = 0
    beverages_total = 0
    utensils_total = 0
    garlic_breads_total = 0
    cannolis_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      if self.order_additional['dipping_sauces']
        self.order_additional['dipping_sauces'].each do |dipping_sauce|
          price = ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0],dipping_sauce[1])
          # puts "Sauce Price : #{price}"
          dipping_sauces_total += price.to_f
        end
      end
      
      if self.order_additional['salads']
        self.order_additional['salads'].each do |salad|
          price = ApplicationController.helpers.get_salad_price_total(self,salad[0],salad[1])
          # puts "Salad Price : #{price}"
          salads_total += price.to_f
        end
      end

      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'].each do |garlic_bread|
          price = ApplicationController.helpers.get_garlic_bread_price_total(self,garlic_bread[0],garlic_bread[1])
          # puts "Salad Price : #{price}"
          garlic_breads_total += price.to_f
        end
      end

      if self.order_additional['cannolis']
        self.order_additional['cannolis'].each do |cannoli|
          price = ApplicationController.helpers.get_cannoli_price_total(self,cannoli[0],cannoli[1])
          # puts "Salad Price : #{price}"
          cannolis_total += price.to_f
        end
      end
      
      if self.order_additional['catering_order'] == "1"
        if self.order_additional['desserts']
          self.order_additional['desserts'].each do |dessert|
            price = ApplicationController.helpers.get_dessert_price_total(dessert[0],dessert[1])
            # puts "Dessert Price : #{price}"
            desserts_total += price.to_f
          end
        end
      end
      
      if self.order_additional['beverages']
        self.order_additional['beverages'].each do |beverage|
          price = ApplicationController.helpers.get_beverage_price_total(beverage[0],beverage[1])
          # puts "Bevrage Price : #{price}"
          beverages_total += price.to_f
        end
      end
      
    end
    
    # puts "Total Sauce Price : #{dipping_sauces_total}"
    
    # puts "Total Salad Price : #{salads_total}"
    
    # puts "Total Dessert Price : #{desserts_total}"
    
    # puts "Total Beverage Price : #{beverages_total}"
    
    order_total = [total_price, dipping_sauces_total, salads_total, garlic_breads_total ,desserts_total, beverages_total].sum
    
    # puts "Order Total (not inc. tax): #{order_total}"
    
    order_total
    
  end
  
  def for_catering
    
    truefalse = false
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      if self.order_additional['catering_order'] == "1"
        truefalse = true
      else
        truefalse = false
      end
      
    else
      truefalse = false
    end
    
    return truefalse
    
  end
  
  
  def total_additional_items_price
    
    additional_items_price = 0
    
    dipping_sauces_total = 0
    salads_total = 0
    desserts_total = 0
    beverages_total = 0
    utensils_total = 0
    garlic_breads_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      self.order_additional['dipping_sauces'] && self.order_additional['dipping_sauces'].each do |dipping_sauce|
        price = ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0],dipping_sauce[1])
        # puts "Sauce Price : #{price}"
        dipping_sauces_total += price.to_f
      end
      
      self.order_additional['salads'].each do |salad|
        price = ApplicationController.helpers.get_salad_price_total(self,salad[0],salad[1])
        # puts "Salad Price : #{price}"
        salads_total += price.to_f
      end

      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'] && self.order_additional['garlic_breads'].each do |garlic_bread|
          price = ApplicationController.helpers.get_garlic_bread_price_total(self,garlic_bread[0],garlic_bread[1])
          # puts "Salad Price : #{price}"
          garlic_breads_total += price.to_f
        end
      end
      
      if self.order_additional['catering_order'] == "1"
        self.order_additional['desserts'] && self.order_additional['desserts'].each do |dessert|
          price = ApplicationController.helpers.get_dessert_price_total(dessert[0],dessert[1])
          # puts "Dessert Price : #{price}"
          desserts_total += price.to_f
        end
      end
      
      self.order_additional['beverages'] && self.order_additional['beverages'].each do |beverage|
        price = ApplicationController.helpers.get_beverage_price_total(beverage[0],beverage[1])
        # puts "Bevrage Price : #{price}"
        beverages_total += price.to_f
      end
      
    end
    
    # puts "Total Sauce Price : #{dipping_sauces_total}"
    
    # puts "Total Salad Price : #{salads_total}"
    
    # puts "Total Dessert Price : #{desserts_total}"
    
    # puts "Total Beverage Price : #{beverages_total}"
    
    additional_items_total = [additional_items_price, dipping_sauces_total, salads_total, garlic_breads_total, desserts_total, beverages_total].sum
    
    # puts "Additional Items Total (not inc. tax): #{additional_items_total}"
    
    return additional_items_total
    
  end
  
  
  
  
  # individual item price totals
  
  def beverages_total

    beverages_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
            
      self.order_additional['beverages'] && self.order_additional['beverages'].each do |beverage|
        price = ApplicationController.helpers.get_beverage_price_total(beverage[0],beverage[1])
        # puts "Bevrage Price : #{price}"
        beverages_total += price.to_f
      end
      
    end
    
    # puts "Total Beverage Price : #{beverages_total}"
    
    return beverages_total
    
  end
  
  
  def salads_total
    
    salads_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      self.order_additional['salads'] && self.order_additional['salads'].each do |salad|
        price = ApplicationController.helpers.get_salad_price_total(self,salad[0],salad[1])
        # puts "Salad Price : #{price}"
        salads_total += price.to_f
      end
      
    end
    
    # puts "Total Salad Price : #{salads_total}"
    
    return salads_total
    
  end

  def garlic_breads_total
    
    garlic_breads_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'].each do |garlic_bread|
          price = ApplicationController.helpers.get_garlic_bread_price_total(self,garlic_bread[0],garlic_bread[1])
          garlic_breads_total += price.to_f
        end
      end
    end
    
    return garlic_breads_total
    
  end
  
  def cannolis_quantity
    
    cannolis_quantity = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      if self.order_additional['cannolis']
        self.order_additional['cannolis'].each do |cannoli|
          cannolis_quantity += cannoli[1].to_i
        end
      end
    end
    
    return cannolis_quantity
    
  end
  
  def desserts_total
    
    desserts_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      if self.order_additional['catering_order'] == "1"
      
        self.order_additional['desserts'] && self.order_additional['desserts'].each do |dessert|
          price = ApplicationController.helpers.get_dessert_price_total(dessert[0],dessert[1])
          # puts "Dessert Price : #{price}"
          desserts_total += price.to_f
        end
      
      end
      
    end
    
    # puts "Total Dessert Price : #{desserts_total}"
    
    return desserts_total

  end
  
  
  
  def dipping_sauces_total
    
    dipping_sauces_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      self.order_additional['dipping_sauces'] && self.order_additional['dipping_sauces'].each do |dipping_sauce|
        price = ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0],dipping_sauce[1])
        # puts "Sauce Price : #{price}"
        dipping_sauces_total += price.to_f
      end
      
    end
    
    # puts "Total Dipping Sauce Price : #{dipping_sauces_total}"
    
    return dipping_sauces_total
    
  end
  
  
  def ordered_at_formatted
    l(self.ordered_at, :format => :for_printer)
  end
  
  def salads_total_formatted
    return number_to_currency(self.salads_total)
  end

  def garlic_breads_total_formatted
    return number_to_currency(self.garlic_breads_total)
  end
  
  def desserts_total_formatted
    return number_to_currency(self.desserts_total)
  end
  
  def beverages_total_formatted
    return number_to_currency(self.beverages_total)
  end
  
  def dipping_sauces_total_formatted
    return number_to_currency(self.dipping_sauces_total)
  end
  
  
  
  
  def sales_tax
    sales_tax = self.total_price * 13/100
    # puts "Sales Tax: #{sales_tax}"
    sales_tax
  end
  
  def sales_tax_inc_delivery
    sales_tax = (self.total_price + self.delivery) * 13/100
    # puts "Sales Tax: #{sales_tax}"
    sales_tax
  end
  
  def delivery
    delivery = 0
    if self.for_pickup?
      delivery = 0
    else
      delivery = Constant::DELIVERY_CHARGE
    end
    delivery
  end

  def tip
    tip = 0
    if self.method_of_payment_id === 4
      tip = self.tip_amount
    end
    tip
  end

  def tip_amount_formatted
    number_to_currency(self.tip_amount)
  end

  def percentage_tip_amount(percentage)
    (self.total_price * percentage.to_i/100).round(2)
  end
  
  def total_price_including_sales_tax
    total = (self.total_price + self.sales_tax) - self.discount_dollar_value
    # puts "Order Total (inc. tax): #{total}"
    total
  end
  
  def total_price_including_sales_tax_inc_delivery
    total = (self.total_price + self.delivery + self.sales_tax_inc_delivery + self.tip_amount) - self.discount_dollar_value
    # puts "Order Total (inc. tax): #{total}"
    total
  end

  def total_price_including_sales_tax_inc_tip
    (self.total_price + self.sales_tax + self.tip_amount) - self.discount_dollar_value
  end

  def total_price_including_sales_tax_inc_delivery_and_tip
    (self.total_price + self.delivery + self.sales_tax_inc_delivery + self.tip_amount) - self.discount_dollar_value
  end
  
  def order_number
    self.ordered_at.to_i
  end
  
  def items_unavailable
    item_count = 0

    if self.order_items.count > 0
      self.order_items.each do |order_item|
        toppings = order_item.product_info['toppings']
        toppings.each do |topping|
          if topping[1]["selected"]
            id = topping[0].gsub(/[^0-9]/i, '')
            unless Topping.exists?(:id => id.to_i, :active => true)
              item_count = item_count + 1
            end
          end
        end
      end
    end

    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
    
      self.order_additional['dipping_sauces'].each do |dipping_sauce|
        if dipping_sauce[1].to_i > 0
          id = dipping_sauce[0].gsub(/[^0-9]/i, '')
          
          unless DippingSauce.exists?(:id => id.to_i, :active => true)
            item_count = item_count + 1
          end
          
        end
      end
    
      self.order_additional['beverages'].each do |beverage|
        if beverage[1].to_i > 0
          id = beverage[0].gsub(/[^0-9]/i, '')
          
          unless Beverage.exists?(:id => id.to_i, :active => true)
            item_count = item_count + 1
          end
        end
      end
      
      self.order_additional['salads'].each do |salad|
        if salad[1].to_i > 0
          id = salad[0].gsub(/[^0-9]/i, '')
          
          unless Salad.exists?(:id => id.to_i, :active => true)
            item_count = item_count + 1
          end
        end
      end

      if self.order_additional['garlic_breads'] 
        self.order_additional['garlic_breads'].each do |garlic_bread|
          if garlic_bread[1].to_i > 0
            id = garlic_bread[0].gsub(/[^0-9]/i, '')
            
            unless GarlicBread.exists?(:id => id.to_i, :active => true)
              item_count = item_count + 1
            end
          end
        end
      end

      if self.order_additional['catering_order'] == "1"
        self.order_additional['desserts'].each do |dessert|
          if dessert[1].to_i > 0
            id = dessert[0].gsub(/[^0-9]/i, '')
            
            unless Dessert.exists?(:id => id.to_i, :active => true)
              item_count = item_count + 1
            end
          end
        end
      end
    
    end

    return item_count   
  end
  
  
  
  def quick_summary
    
    order_summary_arr = []
    
    self.order_items.each do |order_item|
    	# order_summary_arr << order_item.item_title
      order_summary_arr << "#{order_item.item_short_title} <p class='regular-p light'>Quantity: #{order_item.quantity}</p>"
    end
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
	
    	self.order_additional['dipping_sauces'].each do |dipping_sauce|
    		if dipping_sauce[1].to_i > 0
    			order_summary_arr << "<p class='regular-p light'>#{ApplicationController.helpers.get_dipping_sauce_name(dipping_sauce[0])} Dipping Sauce</p>"
    		end
    	end
	
    	self.order_additional['beverages'].each do |beverage|
    		if beverage[1].to_i > 0
    			order_summary_arr << "<p class='regular-p light'>#{ApplicationController.helpers.get_beverage_name(beverage[0])} x #{beverage[1]}</p>"
    		end
    	end
					
    	self.order_additional['salads'].each do |salad|
    		if salad[1].to_i > 0
    			order_summary_arr << "<p class='regular-p light'>#{ApplicationController.helpers.get_salad_name(salad[0])} x #{salad[1]}</p>"
    		end
      end
      
      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'].each do |garlic_bread|
          if garlic_bread[1].to_i > 0
            order_summary_arr << "<p class='regular-p light'>#{ApplicationController.helpers.get_garlic_bread_name(garlic_bread[0])} x #{garlic_bread[1]}</p>"
          end
        end
    	end

    	if self.order_additional['catering_order'] == "1"
    		self.order_additional['desserts'].each do |dessert|
    			if dessert[1].to_i > 0
    				order_summary_arr << "<p class='regular-p light'>#{ApplicationController.helpers.get_dessert_name(dessert[0])} x #{dessert[1]}</p>"
    			end
    		end
    	end
	
      # if self.order_additional['catering_order'] == "1"
      #   self.order_additional['utensils'].each do |utensil|
      #     if utensil[1].to_i > 0
      #       order_summary_arr << "#{ApplicationController.helpers.get_utensil_name(utensil[0])} x #{utensil[1]}"
      #     end
      #   end  
      # end
						
    end

    return order_summary_arr
    
  end
  
  
  def beverages_summary
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
	
    	self.order_additional['beverages'] && self.order_additional['beverages'].each do |beverage|
    		if beverage[1].to_i > 0
    			order_summary_arr << "#{ApplicationController.helpers.get_beverage_name(beverage[0])} x #{beverage[1]}"
    		end
    	end
						
    end

    return order_summary_arr
  end
  
  def beverages_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
	
    	self.order_additional['beverages'] && self.order_additional['beverages'].each do |beverage|
    		if beverage[1].to_i > 0
          inner_arr = []
    			inner_arr << "#{beverage[1]} #{ApplicationController.helpers.get_beverage_name(beverage[0])}"
          inner_arr << number_to_currency( ApplicationController.helpers.get_beverage_price_total(beverage[0],beverage[1]) )
          order_summary_arr << inner_arr
    		end
    	end
						
    end

    return order_summary_arr
  end
  
  def dipping_sauces_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
	
    	self.order_additional['dipping_sauces'] && self.order_additional['dipping_sauces'].each do |dipping_sauce|
    		if dipping_sauce[1].to_i > 0
          inner_arr = []
    			inner_arr << "#{dipping_sauce[1]} #{ApplicationController.helpers.get_dipping_sauce_name(dipping_sauce[0])}"
          inner_arr << number_to_currency( ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0],dipping_sauce[1]) )
          order_summary_arr << inner_arr
    		end
    	end
						
    end

    return order_summary_arr
  end
  
  def salads_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
      @order = Order.find(self.id)
    	self.order_additional['salads'] && self.order_additional['salads'].each do |salad|
    		if salad[1].to_i > 0
          inner_arr = []
    			inner_arr << "#{salad[1]} #{ApplicationController.helpers.get_salad_name(salad[0])}"
          inner_arr << number_to_currency( ApplicationController.helpers.get_salad_price_total(@order,salad[0],salad[1]))
          order_summary_arr << inner_arr
    		end
    	end
						
    end

    return order_summary_arr
  end

  def garlic_breads_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
      @order = Order.find(self.id)
      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'].each do |garlic_bread|
          if garlic_bread[1].to_i > 0
            inner_arr = []
            inner_arr << "#{garlic_bread[1]} #{ApplicationController.helpers.get_garlic_bread_name(garlic_bread[0])}"
            inner_arr << number_to_currency( ApplicationController.helpers.get_garlic_bread_price_total(@order,garlic_bread[0],garlic_bread[1]))
            order_summary_arr << inner_arr
          end
        end
      end
						
    end

    return order_summary_arr
  end

  def cannolis_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
      @order = Order.find(self.id)
      if self.order_additional['cannolis']
        self.order_additional['cannolis'].each do |cannoli|
          if cannoli[1].to_i > 0
            inner_arr = []
            inner_arr << "#{cannoli[1]} #{ApplicationController.helpers.get_cannoli_name(cannoli[0])}"
            inner_arr << "FREE"
            order_summary_arr << inner_arr
          end
        end
      end
						
    end

    return order_summary_arr
  end
  
  def utensils_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
      
      if self.order_additional['catering_order'] == "1"
	
      	self.order_additional['utensils'] && self.order_additional['utensils'].each do |utensil|
      		if utensil[1].to_i > 0
            inner_arr = []
      			inner_arr << "#{utensil[1]} #{ApplicationController.helpers.get_utensil_name(utensil[0])}"
            order_summary_arr << inner_arr
      		end
      	end
      
      end
						
    end

    return order_summary_arr
  end
  
  def desserts_summary_print
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
      
      if self.order_additional['catering_order'] == "1"
	
      	self.order_additional['desserts'] && self.order_additional['desserts'].each do |dessert|
      		if dessert[1].to_i > 0
            inner_arr = []
      			inner_arr << "#{dessert[1]} #{ApplicationController.helpers.get_dessert_name(dessert[0])}"
            inner_arr << number_to_currency( ApplicationController.helpers.get_dessert_price_total(dessert[0],dessert[1]) )
            order_summary_arr << inner_arr
      		end
      	end
      
      end
						
    end

    return order_summary_arr
  end
  
  
  
  def dipping_sauces_summary
  
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
	
    	self.order_additional['dipping_sauces'] && self.order_additional['dipping_sauces'].each do |dipping_sauce|
    		if dipping_sauce[1].to_i > 0
    			order_summary_arr << "#{ApplicationController.helpers.get_dipping_sauce_name(dipping_sauce[0])} Dipping Sauce x #{dipping_sauce[1]}"
    		end
    	end
						
    end

    return order_summary_arr
  
  end
  
  
  
  
  def salads_summary
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
					
    	self.order_additional['salads'] && self.order_additional['salads'].each do |salad|
    		if salad[1].to_i > 0
    			order_summary_arr << "#{ApplicationController.helpers.get_salad_name(salad[0])} x #{salad[1]}"
    		end
    	end
						
    end

    return order_summary_arr
  end

  def garlic_breads_summary
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
			if self.order_additional['garlic_breads']		
        self.order_additional['garlic_breads'].each do |garlic_bread|
          if garlic_bread[1].to_i > 0
            order_summary_arr << "#{ApplicationController.helpers.get_garlic_bread_name(garlic_bread[0])} x #{garlic_bread[1]}"
          end
        end
      end		
    end

    return order_summary_arr
  end
  
  def desserts_summary
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"

    	if self.order_additional['catering_order'] == "1"
    		self.order_additional['desserts'] && self.order_additional['desserts'].each do |dessert|
    			if dessert[1].to_i > 0
    				order_summary_arr << "#{ApplicationController.helpers.get_dessert_name(dessert[0])} x #{dessert[1]}"
    			end
    		end
    	end
						
    end

    return order_summary_arr
  end
  
  def utensils_summary
    order_summary_arr = []
						
    unless self.order_additional.blank? || self.order_additional == "" || self.order_additional == "null"
	
    	if self.order_additional['catering_order'] == "1"
    		self.order_additional['utensils'] && self.order_additional['utensils'].each do |utensil|
    			if utensil[1].to_i > 0
    				order_summary_arr << "#{ApplicationController.helpers.get_utensil_name(utensil[0])} x #{utensil[1]}"
    			end
    		end	
    	end
						
    end

    return order_summary_arr
  end
  
  
  
  
  def to_be_ready_at_formatted
    l(self.to_be_ready_at, :format => :for_printer)
  end

  def date_to_be_ready_at_formatted
    l(self.to_be_ready_at, :format => :for_printer_date)
  end

  def time_to_be_ready_at_formatted
    l(self.to_be_ready_at, :format => :for_printer_time)
  end
  
  # discount dollar value - formatted
  def discount_formatted
    "-#{number_to_currency(self.discount_dollar_value)}"
  end
  
  # subtotal-formatted
  def total_price_formatted
    number_to_currency(self.total_price)
  end
  
  # sales-tax-formatted
  def sales_tax_inc_delivery_formatted
    number_to_currency(self.sales_tax_inc_delivery)
  end
  
  # delivery charge - formatted
  def delivery_formatted
    number_to_currency(self.delivery)
  end
  
  def total_price_including_sales_tax_inc_delivery_formatted
    number_to_currency(self.total_price_including_sales_tax_inc_delivery)
  end
  
  def has_account
    unless self.customer_id.nil?
      return true
    else
      return false
    end
  end
  
  
  def print_and_confirm_order

    self.set_to_be_ready_at!

    if self.discount_code_id.present?
      if self.discount_code.one_time_use
        self.discount_code.update_attributes(one_time_used_at: Time.now, used_order_id: self.id)
      end
    end

    PrintOrderWorker.perform_async(self.id) if Rails.env.production? && self.franchise_location && self.franchise_location.enable_printer_orders
    SendToPosWorker.perform_async(self.id)  if self.franchise_location && self.franchise_location.enable_pos_orders

    # puts 'success'
    # TEST LOCALLY
      # home printer -->
      # printer = Rescpos::Printer.open("192.168.0.29", 9100)
      # printer = Rescpos::Printer.open("192.168.2.29", 9100)

      # report = PrintOrderReport.new(id)
      # printer.print_report(report, :encoding => "UTF-8//IGNORE")
      # printer.close
    
  end
  
  def email_confirmation_to_customer
    OrderMailer.order_confirmation_email(self.id).deliver
  end
  
  def email_confirmation_to_franchise_location
    if self.franchise_location.receive_order_confirmation_emails?
      OrderMailer.franchise_location_order_confirmation_email(self.id).deliver
    end
  end
  
  def email_confirmation_to_admins
    
    @admins = Admin.where(:receive_order_confirmation_emails => true)
    @admins.each do |admin|
      OrderMailer.admin_order_confirmation_email(self.id,admin.id).deliver
    end
    
  end

  def to_be_ready_minutes_string
    if self.for_pickup?
      if self.baked_items_count >= 3
        "30"
      else
        "20"
      end
    else
      if self.baked_items_count >= 3
        "45-55"
      else
        "40"
      end
    end
  end

  def addition_items_exists_for_any_order_item?
    self.order_items.select{|oi| oi.order_additional_print_arr && oi.order_additional_print_arr.count > 0 }.count > 0
  end

  def set_to_be_ready_at!
    to_be_ready_at_potential = Time.now + 40.minutes

    if self.for_pickup?
      if self.baked_items_count >= 3
        to_be_ready_at_potential = self.ordered_at + 30.minutes
        
        if to_be_ready_at_potential >= self.franchise_location.open_for_pickup_on_datetime(to_be_ready_at_potential) + 10.minutes && to_be_ready_at_potential < self.franchise_location.closed_for_pickup_on_datetime(to_be_ready_at_potential) + 10.minutes
          # store open for pickup
        else
          if to_be_ready_at_potential < self.franchise_location.open_for_pickup_on_datetime(to_be_ready_at_potential)
            # store closed for a day then take next day first possible pickup time
            to_be_ready_at_potential = self.franchise_location.try(:pickup_asap_eta) + 10.minutes
          end
        end

        if !self.is_asap && self.to_be_ready_at > to_be_ready_at_potential
          to_be_ready_at_potential = self.to_be_ready_at
        end
      else
        to_be_ready_at_potential = self.ordered_at + 20.minutes
        
        if to_be_ready_at_potential >= self.franchise_location.open_for_pickup_on_datetime(to_be_ready_at_potential) && to_be_ready_at_potential < self.franchise_location.closed_for_pickup_on_datetime(to_be_ready_at_potential)
          # store open for pickup
        else
          if to_be_ready_at_potential < self.franchise_location.open_for_pickup_on_datetime(to_be_ready_at_potential)
            # store not opened yet then take next first possible pickup time
            to_be_ready_at_potential = self.franchise_location.try(:pickup_asap_eta)
          end
        end

        if !self.is_asap && self.to_be_ready_at > to_be_ready_at_potential
          to_be_ready_at_potential = self.to_be_ready_at
        end
      end
    else
      if self.baked_items_count >= 3
        to_be_ready_at_potential = self.ordered_at + 55.minutes
        
        if to_be_ready_at_potential >= self.franchise_location.open_for_delivery_on_datetime(to_be_ready_at_potential) + 15.minutes && to_be_ready_at_potential < self.franchise_location.closed_for_delivery_on_datetime(to_be_ready_at_potential) + 15.minutes
          # store open for delivery
        else
          if to_be_ready_at_potential < self.franchise_location.open_for_delivery_on_datetime(to_be_ready_at_potential) + 15.minutes
            # store not opened yet then take next first possible delivery time
            to_be_ready_at_potential = self.franchise_location.try(:deliver_asap_eta) + 15.minutes
          end
        end
        if !self.is_asap && self.to_be_ready_at > to_be_ready_at_potential
          to_be_ready_at_potential = self.to_be_ready_at
        end
      else
        to_be_ready_at_potential = self.ordered_at + 40.minutes
        
        if to_be_ready_at_potential >= self.franchise_location.open_for_delivery_on_datetime(to_be_ready_at_potential) && to_be_ready_at_potential < self.franchise_location.closed_for_delivery_on_datetime(to_be_ready_at_potential)
          # store open for delivery
        else
          if to_be_ready_at_potential < self.franchise_location.open_for_delivery_on_datetime(to_be_ready_at_potential)
            # store closed for a day then take next day first possible delivery time
            to_be_ready_at_potential = self.franchise_location.try(:deliver_asap_eta)
          end
        end

        if !self.is_asap && self.to_be_ready_at > to_be_ready_at_potential
          to_be_ready_at_potential = self.to_be_ready_at
        end
      end
    end
    self.to_be_ready_at = to_be_ready_at_potential
    self.save
  end

  def to_be_ready_dates_string
    if !self.for_pickup? && self.baked_items_count >= 3
      "#{(self.to_be_ready_at - 10.minutes).strftime(DATE_FORMAT)} - #{(self.to_be_ready_at).strftime(DATE_FORMAT)}(approx.)"
    else
      "#{(self.to_be_ready_at).strftime(DATE_FORMAT)}(approx.)"
    end
  end

  def to_be_ready_dates_string_for_print_date_only
    if !self.for_pickup? && self.baked_items_count >= 3
      start_date = (self.to_be_ready_at - 10.minutes).to_date
      end_date = (self.to_be_ready_at).to_date
      if start_date.to_s == end_date.to_s
        "#{start_date.strftime(DATE_ONLY_FORMAT)}"
      else
        "#{start_date.strftime(DATE_ONLY_FORMAT)} - #{end_date.strftime(DATE_ONLY_FORMAT)}"
      end
    else
      "#{(self.to_be_ready_at).strftime(DATE_ONLY_FORMAT)}"
    end
  end

  def to_be_ready_dates_string_for_print_time_only
    if !self.for_pickup? && self.baked_items_count >= 3
      "#{(self.to_be_ready_at - 10.minutes).strftime(TIME_ONLY_FORMAT)} - #{(self.to_be_ready_at).strftime(TIME_ONLY_FORMAT)}(approx.)"
    else
      "#{(self.to_be_ready_at).strftime(TIME_ONLY_FORMAT)}(approx.)"
    end
  end

  def render_print
    puts PrintOrderReport.new(self.id).render
  end

  def print
    if Rails.env.development?
      printer = Rescpos::Printer.open("192.168.1.154", 9100) 
      report = PrintOrderReport.new(self.id)
      printer.print_report(report, :encoding => "UTF-8//IGNORE")
      printer.close
    end
  end
  
  def baked_items_count
    pizza_calzone_count = self.order_items.map {|oi| oi.quantity.to_i}.sum
    garlic_bread_count = self.order_additional && self.order_additional['garlic_breads'] ? self.order_additional['garlic_breads'].map {|gb| gb[1].to_i}.sum : 0
    total_count = pizza_calzone_count + garlic_bread_count + calzone_count
  end
  
  
  def pizza_count
    pizza_count = 0
    self.order_items.each do |order_item|
      if order_item.product_info['product_type'] == "pizza"
        pizza_count += order_item.quantity.to_i
      end
    end
    return pizza_count
  end
  
  def calzone_count
    calzone_count = 0
    self.order_items.each do |order_item|
      if order_item.product_info['product_type'] == "calzone"
        calzone_count +=1
      end
    end
    return calzone_count
  end

  def potential_pickup_special?
    self.order_items.any?(&:pickup_special?)
  end
  
  def pickup_special?
    self.order_items.any?(&:pickup_special?) && self.for_pickup
  end

  def calculate_pickup_special_pricing_difference
    self.order_items.sum(&:regular_pricing) - self.order_items.sum(&:pickup_special_pricing)
  end
  
  def order_attributes_for_pos
    order_attributes = self.attributes
    toppings = Topping.where(count_as_double: true)
    @toppings = Topping.where(active: true)
    order_attributes["order_items"] = self.order_items.map do |oi|
      # count as double toppings
      order_item_attributes = oi.attributes
      if order_item_attributes['product_info'].present? && order_item_attributes['product_info']['product_name'].present?
        order_item_attributes['product_info']['product_name'] = ActionView::Base.full_sanitizer.sanitize(order_item_attributes['product_info']['product_name'])
      end
      @pizza_size = PizzaSize.where(:name => order_item_attributes["product_info"]["pizza_size"])
      toppings.each do |topping|
        topping_preference = order_item_attributes.fetch("product_info", {}).fetch("toppings", {}).fetch("topping-#{topping.id}", {}).fetch("preference", nil)
        if topping_preference === "Extra"
          order_item_attributes["product_info"]["toppings"]["topping-#{topping.id}"]['preference'] = "Normal"
        end
      end
      
      @toppings.each do |topp|
        if order_item_attributes["product_info"]['product_type'] != "calzone"
          preference = order_item_attributes.fetch("product_info", {}).fetch("toppings", {}).fetch("topping-#{topp.id}", {}).fetch("preference", nil).try(:downcase)
          if preference.present?
            @pizza_size = PizzaSize.where(:name => order_item_attributes["product_info"]["pizza_size"].titlecase).first
            preference = order_item_attributes.fetch("product_info", {}).fetch("toppings", {}).fetch("topping-#{topp.id}", {})["price"] = @pizza_size.send("#{preference}_topping_price").to_f
            if order_item_attributes["product_info"]["toppings"].fetch("topping-#{topp.id}", {}).fetch('name', nil)
              order_item_attributes["product_info"]["toppings"]["topping-#{topp.id}"]['name'] = topp.print_name.present? ? topp.print_name : topp.name
            end
          end
        end
      end
      oi.reload
      oi.product_info['product_name'] = ActionView::Base.full_sanitizer.sanitize(oi.product_info['product_name'])
      order_item_attributes.merge({
        "total_price" => oi.price,
        "custom" => oi.custom,
        "product_name" => oi.product_info['product_name']
      })
    end
    if self.method_of_payment_id === 4
      order_attributes["paid"] = self.payment_transactions.try(:last).try(:transaction_id) ? true : false
    end
    if self.method_of_payment_id === 4 && !self.payment_transactions.try(:last).try(:transaction_id).blank?
      order_attributes["payment_information"] = {
        customer_name: [self.first_name, self.last_name].compact.join(" "),
        order_id: self.try(:order_number),
        transaction_id: self.payment_transactions.try(:last).try(:transaction_id),
        transaction_date: self.payment_transactions.try(:last).try(:transaction_date),
        status: self.payment_transactions.try(:last).try(:status),
        amount: self.payment_transactions.try(:last).try(:amount)
      }
    end
    order_attributes["subtotal"] = self.total_price
    if self.discount_code_id.present? && self.discount_dollar_value > 0
      order_attributes["discount"] = "-#{self.discount_dollar_value}"
    end
    order_attributes["delivery_price"] = self.delivery
    if self.method_of_payment_id === 4 && self.tip_amount > 0
      order_attributes["tip"] = self.tip_amount
    end
    if self.for_pickup?
      order_attributes["tax"] = self.sales_tax
    else
      order_attributes["tax"] = self.sales_tax_inc_delivery
    end
    order_attributes["total"] = self.total_price_including_sales_tax_inc_delivery
    order_attributes
  end  

  def pickup_special?
    self.order_items.any?(&:pickup_special?) && self.for_pickup
  end

  def calculate_pickup_special_pricing_difference
    self.order_items.sum(&:regular_pricing) - self.order_items.sum(&:pickup_special_pricing)
  end

  def order_report
    PrintOrderReport.new(id)
  end

  def order_item_count
    count = self.order_items.map{|oi| oi.quantity.to_f }.sum
    if self.order_additional.present?
      count += self.order_additional.fetch("dipping_sauces", {}).map{|ds| ds[1].to_f }.sum
      count += self.order_additional.fetch("beverages", {}).map{|b| b[1].to_f }.sum
      count += self.order_additional.fetch("garlic_breads", {}).map{|gb| gb[1].to_f }.sum
      count += self.order_additional.fetch("salads", {}).map{|s| s[1].to_f }.sum
      count += self.order_additional.fetch("desserts", {}).map{|d| d[1].to_f }.sum
      count += self.order_additional.fetch("utensils", {}).map{|u| u[1].to_f }.sum
    end
    count.to_i
  end

  def empty_order_additional
    {
      "catering_pizza"=>{},
      "dipping_sauces"=> {
        "dipping_sauce_1"=>"0",
        "dipping_sauce_2"=>"0",
        "dipping_sauce_3"=>"0",
        "dipping_sauce_5"=>"0"
      },
      "beverages"=> {
        "beverage_3"=>"0",
        "beverage_5"=>"0",
        "beverage_8"=>"0",
        "beverage_11"=>"0",
        "beverage_13"=>"0",
        "beverage_17"=>"0",
        "beverage_2"=>"0",
        "beverage_7"=>"0",
        "beverage_10"=>"0",
        "beverage_16"=>"0",
        "beverage_1"=>"0",
        "beverage_4"=>"0",
        "beverage_6"=>"0",
        "beverage_14"=>"0",
        "beverage_15"=>"0"
      },
      "salads"=> {
        "salad_3"=>"0", 
        "salad_1"=>"0", 
        "salad_2"=>"0"
      },
      "garlic_breads"=> {
        "garlic_bread_1"=>"0", 
        "garlic_bread_2"=>"0"
      },
      "cannolis"=> {
        "cannoli_1"=>"0"
      },
      "desserts"=> {
        "dessert_1"=>"0", 
        "dessert_2"=>"0", 
        "dessert_3"=>"0"
      },
      "utensils"=> {
        "utensil_1"=>"0", 
        "utensil_2"=>"0", 
        "utensil_3"=>"0", 
        "utensil_4"=>"0"
      }
    }
  end

  # Filter order items who has topping metioned in toppings filter of discount code
  def get_valid_order_item_ids(filter)
    order_items_ids = []
    filter_toppings_ids = filter.toppings.split(',')

    # CALZONES & PIZZAS
    self.order_items.each do |oi|
      oi_toppings_ids = oi.topping_ids
      # Intersect oi toppings & filter toppings 
      common_toppings_ids = oi_toppings_ids & filter_toppings_ids
      if common_toppings_ids.size > 0
        order_items_ids << oi.id
      end
    end
    order_items_ids 
  end

  def total_price_for_toppings_discount_code_filter(filter)
    
    total_price = 0

    order_items_ids = []

    order_items_ids = get_valid_order_item_ids(filter)

    # CALZONES & PIZZAS
    self.order_items.where(id: order_items_ids).each do |oi|
      total_price += oi.try(:price).to_f * oi.quantity.to_i
    end
    
    # ADDITIONAL ITEMS
    
    dipping_sauces_total = 0
    salads_total = 0
    desserts_total = 0
    beverages_total = 0
    utensils_total = 0
    garlic_breads_total = 0
    cannolis_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      if self.order_additional['dipping_sauces']
        self.order_additional['dipping_sauces'].each do |dipping_sauce|
          price = ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0],dipping_sauce[1])
          # puts "Sauce Price : #{price}"
          dipping_sauces_total += price.to_f
        end
      end
      
      if self.order_additional['salads']
        self.order_additional['salads'].each do |salad|
          price = ApplicationController.helpers.get_salad_price_total(self,salad[0],salad[1])
          # puts "Salad Price : #{price}"
          salads_total += price.to_f
        end
      end

      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'].each do |garlic_bread|
          price = ApplicationController.helpers.get_garlic_bread_price_total(self,garlic_bread[0],garlic_bread[1])
          # puts "Salad Price : #{price}"
          garlic_breads_total += price.to_f
        end
      end

      if self.order_additional['cannolis']
        self.order_additional['cannolis'].each do |cannoli|
          price = ApplicationController.helpers.get_cannoli_price_total(self,cannoli[0],cannoli[1])
          # puts "Salad Price : #{price}"
          cannolis_total += price.to_f
        end
      end
      
      if self.order_additional['catering_order'] == "1"
        if self.order_additional['desserts']
          self.order_additional['desserts'].each do |dessert|
            price = ApplicationController.helpers.get_dessert_price_total(dessert[0],dessert[1])
            # puts "Dessert Price : #{price}"
            desserts_total += price.to_f
          end
        end
      end
      
      if self.order_additional['beverages']
        self.order_additional['beverages'].each do |beverage|
          price = ApplicationController.helpers.get_beverage_price_total(beverage[0],beverage[1])
          # puts "Bevrage Price : #{price}"
          beverages_total += price.to_f
        end
      end
      
    end
    
    order_total = [total_price, dipping_sauces_total, salads_total, garlic_breads_total ,desserts_total, beverages_total].sum
    
    order_total
    
  end

  def calculate_price_without_filter_excluding_deals
    
    total_price = 0

    # CALZONES & PIZZAS
    specials_ids = ["89", "90"] # Delivery and Pickup Special
    self.order_items.where(deal_id: nil).each do |oi|
      if oi.product_info['pizza_preset_id'].present? && !specials_ids.include?(oi.product_info['pizza_preset_id'])
        total_price += oi.try(:price).to_f * oi.quantity.to_i
      end
    end
    
    # ADDITIONAL ITEMS
    
    dipping_sauces_total = 0
    salads_total = 0
    desserts_total = 0
    beverages_total = 0
    utensils_total = 0
    garlic_breads_total = 0
    cannolis_total = 0
    
    unless self.order_additional.blank? || self.order_additional == '' || self.order_additional == 'null'
      
      if self.order_additional['dipping_sauces']
        self.order_additional['dipping_sauces'].each do |dipping_sauce|
          price = ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0],dipping_sauce[1])
          # puts "Sauce Price : #{price}"
          dipping_sauces_total += price.to_f
        end
      end
      
      if self.order_additional['salads']
        self.order_additional['salads'].each do |salad|
          price = ApplicationController.helpers.get_salad_price_total(self,salad[0],salad[1])
          # puts "Salad Price : #{price}"
          salads_total += price.to_f
        end
      end

      if self.order_additional['garlic_breads']
        self.order_additional['garlic_breads'].each do |garlic_bread|
          price = ApplicationController.helpers.get_garlic_bread_price_total(self,garlic_bread[0],garlic_bread[1])
          # puts "Salad Price : #{price}"
          garlic_breads_total += price.to_f
        end
      end

      if self.order_additional['cannolis']
        self.order_additional['cannolis'].each do |cannoli|
          price = ApplicationController.helpers.get_cannoli_price_total(self,cannoli[0],cannoli[1])
          # puts "Salad Price : #{price}"
          cannolis_total += price.to_f
        end
      end
      
      if self.order_additional['catering_order'] == "1"
        if self.order_additional['desserts']
          self.order_additional['desserts'].each do |dessert|
            price = ApplicationController.helpers.get_dessert_price_total(dessert[0],dessert[1])
            # puts "Dessert Price : #{price}"
            desserts_total += price.to_f
          end
        end
      end
      
      if self.order_additional['beverages']
        self.order_additional['beverages'].each do |beverage|
          price = ApplicationController.helpers.get_beverage_price_total(beverage[0],beverage[1])
          # puts "Bevrage Price : #{price}"
          beverages_total += price.to_f
        end
      end
      
    end
    
    order_total = [total_price, dipping_sauces_total, salads_total, garlic_breads_total ,desserts_total, beverages_total].sum
    
    order_total
    
  end

  def discount_on_amount(discount_code, total_price)
    discounted_dollar_value = 0.0
    if discount_code.discount_type == "percent"
      discounted_dollar_value = (total_price * discount_code.value.to_f / 100).round(2)
    else
      discounted_dollar_value = discount_code.value.to_f
    end
    if self.update_attributes(discount_promo_code: discount_code.code, discount_code_id: discount_code.id, discount_dollar_value: discounted_dollar_value)
      return true
    else 
      return false
    end
  end

  def check_discount_filters_with_topping(discount_code)
    valid = true
    discount_code.discount_code_filters.each do |filter|
      case filter.filter_type
        when "email"
          valid = false if self.email != filter.email
        when "franchise_location"
          valid = false if self.franchise_location.id != filter.franchise_location_id
        when "toppings"
          order_item_ids = get_valid_order_item_ids(filter) 
          valid = false if order_item_ids.size === 0
      end
    end

    if valid 
      # find order items who has any of toppings
      # calculate subtotal for any toppings
      filter = discount_code.discount_code_filters.where(filter_type: 'toppings').first
      # Here subtotal need to calculate bcoz order items need to select based on toppings
      price = total_price_for_toppings_discount_code_filter(filter)
      discount_on_amount(discount_code, price)
    else
      self.update_attributes(discount_promo_code: nil, discount_code_id: nil, discount_dollar_value: 0.0)
      return false
    end
  end

  def check_discount_filters_without_topping(discount_code)
    valid = true
    discount_code.discount_code_filters.each do |filter|
      case filter.filter_type
        when "email"
          valid = false if self.email != filter.email
        when "franchise_location"
          valid = false if self.franchise_location.id != filter.franchise_location_id
      end
    end
    
    if valid
      discount_on_amount(discount_code, self.total_price)
    else 
      self.update_attributes(discount_promo_code: nil, discount_code_id: nil, discount_dollar_value: 0.0)
      return false
    end
  end

  def apply_discount_filters(discount_code)
    filters_count = discount_code.discount_code_filters.count
    
    if filters_count === 0
      # there is no filter with this discount code
      # so directly calculating on subtotal
      if discount_code.exclude_deals
        if self.order_items.where(deal_id: nil).count === 0
          # no order item except deals present in order
          self.update_attributes(discount_promo_code: nil, discount_code_id: nil, discount_dollar_value: 0.0)
          return false
        else
          price = calculate_price_without_filter_excluding_deals
          discount_on_amount(discount_code, price)
        end
      else
        discount_on_amount(discount_code, self.total_price)
      end
    else
      toppings_filter = discount_code.discount_code_filters.where(filter_type: "toppings")
      if toppings_filter.present?
        check_discount_filters_with_topping(discount_code)
      else
        check_discount_filters_without_topping(discount_code)
      end
    end
 
  end

  def apply_discount(discount_code)
    # check discount code is one time use?
    if discount_code.one_time_use
      if discount_code.one_time_used_at.nil?
        # discount code not used
        result = apply_discount_filters(discount_code)
      else
        # discount code already used
        self.update_attributes(discount_promo_code: nil, discount_code_id: nil, discount_dollar_value: 0.0)
        return false
      end
    else
      result = apply_discount_filters(discount_code)
    end
    result
  end
  
  private

    def remove_null
      # self.update_attributes(:order_additional => nil)
    end

end
