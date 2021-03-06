class PizzaPreset < ActiveRecord::Base

  attr_accessible :active, :product_image, :product_info, :product_name, :product_image, :pizza_image_flat, :pizza_image_angled, :pizza_category_id, :pizzaiolo_favourites, :spicy, :customer_favourites, :vegan, :health_check, :nut_free, :show_images, :gluten_free_only, :calories, :description, :is_product_combo, :is_10_inches, :product_combo_id, :is_new_pizza, :sort
  attr_accessible :image_flat
  attr_accessible :tag_list
  
  
  before_update :save_id_in_json
  before_save :create_or_update_slug

  serialize :product_info, JSON
  
  belongs_to :pizza_category
  belongs_to :product_combo

  acts_as_taggable
  
  # upload images into the preset
  mount_uploader :pizza_image_flat, ProductImageUploader
  mount_uploader :pizza_image_angled, ProductImageUploader
  
  after_update :expire_fragments
  after_create :expire_fragments
  
  LIST_OF_SAUCE = Topping.where(:active => true).where(:type_of_topping_id => 3)
  LIST_OF_CHEESES = Topping.where(:active => true).where(:type_of_topping_id => 4)
  
  def number_of_pizzas?
    number_of_pizzas = 1
    if self.is_product_combo 
      number_of_pizzas = self.product_combo.try(:no_of_pizza) || 1
    end
    number_of_pizzas
  end

  def toppings
    
    toppings = []
    toppings_end = []
    
    if self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.find_by_id(t[1]["id"])
            if @topping
              unless @topping.move_to_end_of_description?
                toppings << @topping.name
              else
                toppings_end << @topping.name
              end
            end
          end
        end
      end
    end
    
    if self.product_info['product_type'] == "calzone"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.find(t[1]["id"])
            unless @topping.move_to_end_of_description?
              toppings << @topping.name
            else
              toppings_end << @topping.name
            end
          end
        end
      end
    end
    
    return toppings.sort.push(toppings_end.sort).flatten
    
  end
  
  
  
  
  # this is new, to calculate out the rounded number of paid toppings per calzone or pizza
  def num_paid_toppings
    
    # get pricing info from the DB based on the pizza size
    @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titlecase).first
    
    # basic price of the pizza based on size
    base_price = @pizza_size.price
    
    # topping price (based on the size fo the pizza)
    topping_price = @pizza_size.topping_price
    
    topping_price_running_total = 0
    
    topping_running_total = 0
    
    toppings_selected = 0
    
    topping_multiple = 0
  
    @toppings = self.product_info['toppings']
    @toppings.each do |t|
      
      if t[1]["selected"]
        
        @topping = Topping.find(t[1]["id"])
        unless @topping.free_topping?
          
          # if the topping is not free, then...
          
          # figure out the preference multiple
          case t[1]["preference"]
          when "Extra"
            if @topping.type_of_topping.name == "Sauces"
              preference_multiple = 1
            else
              preference_multiple = 2
            end
          when "Double"
            preference_multiple = 3
          else
            preference_multiple = 1
          end
          
          
          # figure out the position multiple
          puts t[1]["position"]
          case t[1]["position"]
          when "Whole Pizza"
            position_multiple = 1
          else
            position_multiple = 0.5
          end
          
          topping_multiple = preference_multiple * position_multiple
          
          topping_running_total += topping_multiple
          
          
        end
        
        if @topping.free_topping? && @topping.type_of_topping.name == "Cheeses"
          
          # if the topping is free, but is a cheese
          
          # figure out the preference multiple
          case t[1]["preference"]
          when "Extra"
            preference_multiple = 1
          when "Double"
            preference_multiple = 2
          else
            preference_multiple = 0
          end
          
          
          # figure out the position multiple
          puts t[1]["position"]
          case t[1]["position"]
          when "Whole Pizza"
            position_multiple = 1
          else
            position_multiple = 0.5
          end
          
          topping_multiple = preference_multiple * position_multiple
          
          topping_running_total += topping_multiple
          
          
        end
        
        
      end
    end
    
    
    puts "This pizza has the equivelent of #{topping_running_total} topping(s) selected, with a rounded up figure of #{topping_running_total.ceil} topping(s) "
    
    return topping_running_total.ceil
    
  end
  
  
  
  
  
  
  
  def paid_toppings
    
    toppings = []
    toppings_end = []
    
    if self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.where(:id => t[1]["id"], :free_topping => false).first
            if @topping
              unless @topping.move_to_end_of_description?
                toppings << @topping.name
              else
                toppings_end << @topping.name
              end
            end
          end
        end
      end
    end
    
    if self.product_info['product_type'] == "calzone"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.where(:id => t[1]["id"], :free_topping => false).first
            if @topping
              unless @topping.move_to_end_of_description?
                toppings << @topping.name
              else
                toppings_end << @topping.name
              end
            end
          end
        end
      end
    end
    
    return toppings.sort.push(toppings_end.sort).flatten
    
  end
  
  
  def total_paid_toppings
    
    topping_price_running_total = 0
    
    topping_running_total = 0
    
    toppings_selected = 0
    
    topping_multiple = 0
    
    if self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
          
            @topping = Topping.find(t[1]["id"])
            unless @topping.free_topping?
          
              # figure out the preference multiple
              case t[1]["preference"]
              when "Extra"
                if @topping.type_of_topping.name == "Sauces"
                  preference_multiple = 2
                else
                  preference_multiple = 2
                end
              when "Double"
                preference_multiple = 3
              else
                preference_multiple = 1
              end
                    
              # figure out the position multiple
              case t[1]["position"]
              when "Whole Pizza"
                position_multiple = 1
              else
                position_multiple = 0.5
              end
          
              topping_multiple = preference_multiple * position_multiple
          
              topping_running_total += topping_multiple
          
            end
            
          end
        end
      end
    end
    
    return topping_running_total.ceil
    
  end
  
  
  
  
  def get_price_at_size(size)
    
    if self.product_info['product_type'] == "pizza"
      
      # get pricing info from the DB based on the pizza size
      @pizza_size = size
      
      # basic price of the pizza based on size
      base_price = @pizza_size.price
      

      # check for deep dish
      if self.product_info['pizza_crust_style']
  
        @pizza_crust_style = PizzaCrustStyle.where(:slug => self.product_info['pizza_crust_style']).first
  
        if @pizza_crust_style && @pizza_crust_style.deep_dish_pricing?
          puts "It's deep dish!"
          base_price += @pizza_size.deep_dish_option_price
        end
        
      end
      
      
      
      # topping price (based on the size fo the pizza)
      topping_price = @pizza_size.topping_price
      
      topping_price_running_total = 0
      
      toppings_selected = 0
      
      topping_price_running_total = self.num_paid_toppings * topping_price
      
      # get the price of the order itme as a line item...
      return base_price + topping_price_running_total
      
    end
  
  end

  def current_size_price
    order_item = OrderItem.new
    order_item.product_info = self.product_info
    order_item.price.to_f
  end

  def price_difference_list
    @order_item = OrderItem.new
    @order_item.product_info = self.product_info
    current_size_price = @order_item.price.to_f
    current_size = @order_item.product_info["pizza_size"]
    size_prices = []
    if @order_item
      exclude_pizza_size = ['gluten_free','gluten_free_small','cauliflower_s','cauliflower_m']
      PizzaSize.where(active: true, is_catering: false).each do |pizza_size|
        size_name = pizza_size.name.downcase.gsub(" ", "_")
        if !exclude_pizza_size.include? size_name
          size_price = {}
          size_external_name = pizza_size.external_name + " " + pizza_size.num_slices
          @order_item.product_info["pizza_size"] = size_name
          price_difference = @order_item.price.to_f
          size_price["size_name"] = size_name
          size_price["size_external_name"] = size_external_name
          size_price["price_difference"] = price_difference
          size_prices.push(size_price)
        end 
      end
    end
    @order_item.product_info["pizza_size"] = current_size
    size_prices
  end

  def price_difference_list_gluten_free
    @order_item = OrderItem.new
    @order_item.product_info = self.product_info
    current_size_price = @order_item.price.to_f
    current_size = @order_item.product_info["pizza_size"]
    size_prices = []
    if @order_item
      include_pizza_size = ['gluten_free','gluten_free_small','cauliflower_s',"cauliflower_m"]
      PizzaSize.where(active: true, is_catering: false).order("position ASC").each do |pizza_size|
        size_name = pizza_size.name.downcase.gsub(" ", "_")
        if include_pizza_size.include? size_name
          size_price = {}
          size_external_name = pizza_size.external_name + " " + pizza_size.num_slices
          @order_item.product_info["pizza_size"] = size_name
          price_difference = @order_item.price.to_f
          size_price["size_name"] = size_name
          size_price["size_external_name"] = size_external_name
          size_price["price_difference"] = price_difference
          size_prices.push(size_price)
        end 
      end
    end
    @order_item.product_info["pizza_size"] = current_size
    size_prices
  end

  def price_difference_list_catering
    @order_item = OrderItem.new
    @order_item.product_info = self.product_info
    current_size_price = @order_item.price.to_f
    current_size = @order_item.product_info["pizza_size"]
    size_prices = []
    if @order_item
      exclude_pizza_size = []
      PizzaSize.where(active: true, is_catering: false).order(:position).each do |pizza_size|
        size_name = pizza_size.name.downcase.gsub(" ", "_")
        if !exclude_pizza_size.include? size_name
          size_price = {}
          size_external_name = pizza_size.external_name + " " + pizza_size.num_slices
          @order_item.product_info["pizza_size"] = size_name
          price_difference = @order_item.price.to_f
          size_price["size_name"] = size_name
          size_price["size_external_name"] = size_external_name
          size_price["price_difference"] = price_difference
          size_prices.push(size_price)
        end 
      end
    end
    @order_item.product_info["pizza_size"] = current_size
    size_prices
  end
  
  def price_difference_list_for_10inches
    @order_item = OrderItem.new
    @order_item.product_info = self.product_info
    current_size_price = @order_item.price.to_f
    current_size = @order_item.product_info["pizza_size"]
    size_prices = []
    if @order_item
      exclude_pizza_size = ['gluten_free','gluten_free_small','cauliflower_s','cauliflower_m']
      PizzaSize.where(active: true, is_catering: true).each do |pizza_size|
        size_name = pizza_size.name.downcase.gsub(" ", "_")
        if !exclude_pizza_size.include? size_name
          size_price = {}
          size_external_name = pizza_size.external_name + " " + pizza_size.num_slices
          @order_item.product_info["pizza_size"] = size_name
          price_difference = @order_item.price.to_f
          size_price["size_name"] = size_name
          size_price["size_external_name"] = size_external_name
          size_price["price_difference"] = price_difference
          size_prices.push(size_price)
        end 
      end
    end
    @order_item.product_info["pizza_size"] = current_size
    size_prices
  end
  # validations

  def to_param
    self.slug
  end
  
  private
  
    def save_id_in_json
      self.product_info['pizza_preset_id'] == self.id    
      puts self.id
    end
    
    def expire_fragments
      ActionController::Base.new.expire_fragment('pizza_presets')
      ActionController::Base.new.expire_fragment('pizza_presets_menu')
      ActionController::Base.new.expire_fragment('pizza_presets_nutritional')
    end

    def create_or_update_slug
      if self.slug.nil?
        self.slug = self.product_name.try(:parameterize)
      end
    end
  
end
