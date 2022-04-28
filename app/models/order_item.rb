class OrderItem < ActiveRecord::Base
  attr_accessor :num_paid_toppings
  belongs_to :order
  attr_accessible :product_info, :product_name, :product_type, :order_id, :quantity, :combo_additional, :deal_id
  
  serialize :product_info, JSON
  serialize :combo_additional, JSON
  
  include ActionView::Helpers

  TEN_INCH_PIZZA_PRICE = 11.00

  def no_of_pizzas?
    number_of_pizzas = 1
    if self.product_info["pizza_preset_id"] 
      @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
      if @pizza_preset.is_product_combo
        number_of_pizzas = @pizza_preset.try(:product_combo).try(:no_of_pizza) || 1
      end
    end
    number_of_pizzas
  end

  def pizza_preset
    @pizza_preset = {}
    pizza_preset_id = self.product_info['pizza_preset_id']
    if pizza_preset_id.present?
      @pizza_preset = PizzaPreset.find_by_id(self.product_info['pizza_preset_id'])
    end
    @pizza_preset
  end

  def pizza_preset_description?
    self.pizza_preset.description.present? && self.pizza_preset.description != nil
  end

  def pizza_preset_description
    self.pizza_preset.try(:description) || ''
  end

  def deal_title
    self.try(:pizza_preset).try(:product_combo).try(:title)
  end

  def freeze_pizza_topping(topping_id)
    freeze_toppings = []
    if self.product_info["pizza_preset_id"] && self.pizza_position.present?
      @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
      case self.pizza_position
        when 1
          freeze_toppings = @pizza_preset.try(:product_combo).try(:first_pizza_freeze_toopings).to_s.split(", ")
        when 2
          freeze_toppings = @pizza_preset.try(:product_combo).try(:second_pizza_freeze_toopings).to_s.split(", ")
        when 3
          freeze_toppings = @pizza_preset.try(:product_combo).try(:third_pizza_freeze_toopings).to_s.split(", ")
      end
      return freeze_toppings.include? topping_id.to_s
    else
      return false
    end
  end

  def toppings
    
    toppings = []
    toppings_end = []
    
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

  def topping_ids
    
    toppings = []
    
    if self.product_info['toppings']
      @toppings = self.product_info['toppings']
      @toppings.each do |t|
        if t[1]["selected"]
          toppings << t[1]["id"]
        end
      end
    end
    toppings
  end
    

  # return product image

  def item_image
    pizza_preset = self.product_info["pizza_preset_id"] 
    
    if self.product_info['product_type'] == "calzone"
      image = '/system/uploads/calzone_preset/calzone_image_flat/2/size_300_product_image.jpg'
    else
      pizza_preset = PizzaPreset.find_by_id(pizza_preset)
      image = pizza_preset ? pizza_preset.pizza_image_flat.size_300.url : nil
    end
      return image
  end

  def item_title_for_print
    if self.deal_id.present?
      return ActionView::Base.full_sanitizer.sanitize(raw "#{self.product_info['product_name'].titleize}")
    else
      return ActionView::Base.full_sanitizer.sanitize(raw "#{self.product_info['product_name'].titleize}")
    end
  end

  # define and return the name of the product as it should appear when selected.
  def item_title

    if self.product_info.present? && self.product_info.fetch('product_name', "") == "Pickup Special" && self.order && !self.order.for_pickup?
      self.product_info['product_name'] = "Pickup Special (Delivery Price)"
    end
    
    # puts self.product_info['product_type']
    if self.product_info.present? && self.product_info.fetch('product_type', "") == "pizza"
      
      pizza_size = self.product_info.fetch('pizza_size', "").try(:titleize)
      @pizza_size = PizzaSize.where("name" => pizza_size).first
      puts @pizza_size.external_name
      pizza_size = self.product_info['pizza_size']
      unless ["cauliflower", "gluten-free"].select{|size_string| pizza_size.include?(size_string) }.size > 0
      #unless self.product_info['pizza_size'].include? "gluten-free"
        if self.deal_id.present?
          return raw "#{self.product_info.fetch('product_name', "").try(:titleize)} <p>Size: #{@pizza_size.try(:external_name)}</p><p>Crust: #{self.product_info.fetch('pizza_crust', "").try(:titlecase)}</p><p>Crust Style: #{self.product_info.fetch('pizza_crust_style', "").try(:titlecase)}</p><p>Special Instructions: #{self.product_info.fetch('special_instructions', "").try(:titlecase)}</p>"
        else
          return raw "#{self.product_info.fetch('product_name', "").try(:titleize)} <p>Size: #{@pizza_size.try(:external_name)}</p><p>Crust: #{self.product_info.fetch('pizza_crust', "").try(:titlecase)}</p><p>Crust Style: #{self.product_info.fetch('pizza_crust_style', "").try(:titlecase)}</p><p>Special Instructions: #{self.product_info.fetch('special_instructions', "").try(:titlecase)}</p>"
        end
      else
        return raw "#{self.product_info.fetch('product_name', "").try(:titleize)} <p>Size: #{@pizza_size.try(:external_name)}</p><p>Special Instructions: #{self.product_info.fetch('special_instructions', "").try(:titlecase)}</p>"
      end
      
    end
    
    if self.product_info.present? && self.product_info.fetch('product_type', "") == "calzone"
      return "#{self.product_info.fetch('product_name', "")}"
    end
    
  end

  def item_short_title
    # puts self.product_info['product_type']
    if self.product_info['product_type'] == "pizza"
      
      pizza_size = self.product_info['pizza_size'].titleize
      @pizza_size = PizzaSize.where("name" => pizza_size).first
      puts @pizza_size.external_name
      pizza_size = self.product_info['pizza_size']
      unless ["cauliflower", "gluten-free"].select{|size_string| pizza_size.include?(size_string) }.size > 0
      #unless self.product_info['pizza_size'].include? "gluten-free"
        return raw "<p class='static-header green'>#{self.product_info['product_name'].titleize}</p><p class='regular-p light'>#{@pizza_size.external_name}, #{self.product_info['pizza_crust_style'].titlecase}, #{self.product_info['pizza_crust'].titlecase} Crust</p>"
      else
        return raw "<p class='static-header green'>#{self.product_info['product_name'].titleize}</p><p class='regular-p light'>(#{@pizza_size.external_name})</p>"
      end
      
    end
    
    if self.product_info['product_type'] == "calzone"
      return "<p class='static-header green'>#{self.product_info['product_name']}</p>"
    end
  end
  
  
  # define and return the name of the product as it should appear when selected.
  def item_title_email

    if self.product_info['product_name'] == "Pickup Special" && self.order && !self.order.for_pickup?
      self.product_info['product_name'] = "Pickup Special (Delivery Price)"
    end
    
    # puts self.product_info['product_type']
    if self.product_info['product_type'] == "pizza"
      
      if self.custom == true
        name = "Custom Pizza"
      else
        pizza_size = self.product_info['pizza_size'].titleize
        @pizza_size = PizzaSize.where("name" => pizza_size).first
        name = @pizza_size.external_name
      end
      
      pizza_size = self.product_info['pizza_size']
      unless ["cauliflower", "gluten-free"].select{|size_string| pizza_size.include?(size_string) }.size > 0
      #unless self.product_info['pizza_size'].include? "gluten-free"
        return raw "#{name} <small>(#{@pizza_size.external_name}, Crust: #{self.product_info['pizza_crust'].titlecase}, Crust Style: #{self.product_info['pizza_crust_style'].titlecase})</small>"
      else
        return raw "#{name} <small>(#{@pizza_size.external_name})</small>"
      end
      
    end
    
    if self.product_info['product_type'] == "calzone"
      return "#{self.product_info['product_name']}"
    end
    
  end

  def popup_message
    @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
    if @pizza_preset.present? && @pizza_preset.is_product_combo && @pizza_preset.product_combo.try(:title) == "Delivery Special"
      if order_additional_count <= 1 && toppings_count < 2
        return "Please select 2 toppings and (2 pops or 2 dips)"
      elsif toppings_count < 2
        return "Please select at least 2 toppings"
      elsif order_additional_count <= 1
        return "Please select 2 pops or 2 dips"
      else
        # default message
        return "Please select 2 pops or 2 dips"
      end
    end
  end
  
  def show_popup
    @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
    if @pizza_preset.present? && @pizza_preset.is_product_combo && @pizza_preset.product_combo.try(:title) == "Delivery Special"
      order_additional_count <= 1 || toppings_count < 2
    else
      false
    end 
  end

  # For delivery special toppings count
  def toppings_count
    count = 0
    sauces_count = 0
    cheeses_count = 0
    topping_types = ["Vegetables", "Meat", "Plant Based", "Sauces", "Cheeses"]
    if self.product_info['toppings']
      self.product_info['toppings'].each do |t|
        if t[1]["selected"]
          @topping = Topping.find(t[1]["id"])
          if topping_types.include? @topping.try(:type_of_topping).try(:name)
            count = count + 1
            if @topping.try(:type_of_topping).try(:name) === "Sauces"
              sauces_count = sauces_count + 1
            end
            if @topping.try(:type_of_topping).try(:name) === "Cheeses"
              cheeses_count = cheeses_count + 1
            end
          end
        end
      end
      if sauces_count >= 1
        count = count - 1 if count > 0
      end
      if cheeses_count >= 1
        count = count - 1 if count > 0
      end
    end
    count
  end

  def order_additional_count
    if self.product_info.fetch("order_additional", nil)
      dippings = self.product_info.fetch("order_additional", {}).fetch("dipping_sauces", {})
      dippings_count = dippings.values.map(&:to_f).sum

      beverages = self.product_info.fetch("order_additional", {}).fetch("beverages", {})
      beverages_count = beverages.values.map(&:to_f).sum

      total_count = [dippings_count, beverages_count].sum
    else
      0.0
    end
  end
  
  def paid_toppings
    
    toppings = []
    
    if self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.where(:id => t[1]["id"], :free_topping => false).first
            if @topping
              position = ""
              preference = ""
              unless t[1]["position"] == 'Whole Pizza'
                position = t[1]["position"]
              end
              unless t[1]["preference"] == 'Normal'
                preference = t[1]["preference"]
              end
              toppings << "#{@topping.name}#{unless position == "" && preference == "" then ": " end}#{unless position == "" then position end}#{unless position == "" || preference == "" then " / " end}#{unless preference == "" then preference end}"
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
              preference = ""
              unless t[1]["preference"] == 'Normal'
                preference = t[1]["preference"]
              end
              toppings << "#{@topping.name}#{unless preference == "" then ": " end}#{unless preference == "" then preference end}"
            end
          end
        end
      end
    end
    
    return toppings
    
  end
  
  
  def toppings
    
    toppings = []
    
    if self.product_info.present? && self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.find_by_id(t[1]["id"])
            if @topping
              position = ""
              preference = ""
              unless t[1]["position"] == 'Whole Pizza'
                position = t[1]["position"]
              end 
              unless t[1]["preference"] == 'Normal'
                preference = t[1]["preference"]
              end
              toppings << "#{@topping.name}#{unless position == "" && preference == "" then ": " end}#{unless position == "" then position end}#{unless position == "" || preference == "" then " / " end}#{unless preference == "" then preference end}"
            end
          end
        end
      end
    end
    
    if self.product_info.present? && self.product_info['product_type'] == "calzone"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.find_by_id(t[1]["id"])
            if @topping
              preference = ""
              unless t[1]["preference"] == 'Normal'
                preference = t[1]["preference"]
              end
              toppings << "#{@topping.name}#{unless preference == "" then ": " end}#{unless preference == "" then preference end}"
            end
          end
        end
      end
    end
    
    return toppings
    
  end

  
  
  def toppings_1
    
    toppings = []
    
    if self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.find_by_id(t[1]["id"])        

            if @topping
              position = ""
              preference = ""
              # unless t[1]["position"] == 'Whole Pizza'
              #   position = t[1]["position"]
              # end
              position = t[1]["position"]
              
              unless t[1]["preference"] == 'Normal'
                preference = t[1]["preference"]
              end

              if @topping.count_as_double === true && t[1]['preference'] === 'Extra'
                preference = ""
              end
              toppings << "#{position} #{@topping.name} #{": " unless preference.blank? } #{preference}" if @topping
            
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
            @topping = Topping.find_by_id(t[1]["id"])
            if @topping
              preference = ""
              unless t[1]["preference"] == 'Normal'
                preference = t[1]["preference"]
              end
              toppings << "#{@topping.name} #{unless preference == "" then ": " end} #{unless preference == "" then preference end}"
            end
          end
        end
      end
    end

    return toppings
    
  end
  
  def toppings_franchise_email
    
    toppings = []
    
    if self.product_info['product_type'] == "pizza"
      if self.product_info['toppings']
        @toppings = self.product_info['toppings']
        @toppings.each do |t|
          if t[1]["selected"]
            @topping = Topping.find_by_id(t[1]["id"])
            if @topping

              position = t[1]["position"]
              preference = t[1]["preference"]

              toppings << "#{@topping.name} (Side: #{position} Amount: #{preference})"
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
            if @topping
              preference = ""
              preference = t[1]["preference"]
              toppings << "#{@topping.name} (Amount: #{preference})"
            end
          end
        end
      end
    end
    
    return toppings
    
  end
  
  
  
  # this is new, to calculate out the rounded number of paid toppings per calzone or pizza
  # def num_paid_toppings
    
  #   if self.product_info['product_type'] == "pizza"
  #     # get pricing info from the DB based on the pizza size
  #     @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titlecase).first
      
  #     # basic price of the pizza based on size
  #     base_price = @pizza_size.price
      
  #     # topping price (based on the size fo the pizza)
  #     topping_price = @pizza_size.topping_price
      
  #     topping_price_running_total = 0
      
  #     topping_running_total = 0
      
  #     toppings_selected = 0
      
  #     topping_multiple = 0

  #     first_sauce_free = true
  #     first_cheese_free = true
    
  #     @toppings = self.product_info['toppings']
      
  #     @toppings.each do |t|
        
  #       if t[1]["selected"]
          
  #         @topping = Topping.find(t[1]["id"])
          
  #         topping_count = 0
          
  #         unless @topping.free_topping?
           
  #           topping_count += 1 
  #           # first sause will be free
  #           if @topping.type_of_topping_id === 3 && first_sauce_free === true
  #             topping_count = topping_count-1 
  #             first_sauce_free = false
  #           end
  #            # first cheese will be free
  #           if @topping.type_of_topping_id === 4 && first_cheese_free === true
  #             topping_count = topping_count-1 
  #             first_cheese_free = false
  #           end
  #         end
          
  #         # figure out the preference multiple
  #         case t[1]["preference"]
  #         when "Extra"
  #           unless @topping.extra_free?
  #             topping_count += 1
  #           end
  #         when "Double"
  #           unless @topping.double_free?
  #             topping_count += 2
  #           end
  #         end
          
          
  #         # figure out the position multiple
  #         case t[1]["position"]
  #         when "Whole Pizza"
  #           position_multiple = 1
  #         else
  #           position_multiple = 0.5
  #         end
          
          
  #         topping_multiple = topping_count * position_multiple
          
  #         topping_running_total += topping_multiple
          
  #       end

  #     end
      
  #     puts "This pizza has the equivelent of #{topping_running_total} topping(s) selected, with a rounded up figure of #{topping_running_total.ceil} topping(s) "
      
  #     return topping_running_total.ceil
      
  #   end
    
    # if self.product_info['product_type'] == "calzone"
      
    #   @calzone_preset = CalzonePreset.find(self.product_info['calzone_preset_id'])
    #   base_price = @calzone_preset.price
    #   topping_price = @calzone_preset.topping_price
      
    #   topping_price_running_total = 0
      
    #   topping_running_total = 0
      
    #   toppings_selected = 0
      
    #   @toppings = self.product_info['toppings']
    #   @toppings.each do |t|
        
    #     if t[1]["selected"]
          
    #       @topping = Topping.find(t[1]["id"])
          
    #       topping_count = 0
          
    #       unless @topping.free_topping?
    #         topping_count += 1 
    #       end
          
    #       # figure out the preference multiple
    #       case t[1]["preference"]
    #       when "Extra"
    #         unless @topping.extra_free?
    #           topping_count += 1
    #         end
    #       when "Double"
    #         unless @topping.double_free?
    #           topping_count += 2
    #         end
    #       end
          
    #       topping_running_total += topping_count
          
    #     end
        
    #   end
      
    #   # output the total number of toppings based on the rounding math...
    #   puts "This calzone has the equivelent of #{topping_running_total} topping(s) selected, with a rounded up figure of #{topping_running_total.ceil} topping(s) "
      
    #   # calculate the total of the charagble toppings:
    #   return topping_running_total.ceil
      
      
    # end
    
  # end
  

  def price_of_paid_toppings

    if self.product_info['product_type'] == "pizza"
      # get pricing info from the DB based on the pizza size
      @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titlecase).first
      
      # basic price of the pizza based on size
      base_price = @pizza_size.price

      topping_running_total = 0
      first_sauce_free = true
      first_cheese_free = true
    
      @toppings = self.product_info['toppings']
      
      @toppings_ar = Topping.where(id: @toppings.values.map{|t| t["id"] if t["selected"] } ).reject(&:nil?)
      @toppings_ar.group_by(&:type_of_topping_id).each do |topping_type_id, toppings|
        type_of_topping = TypeOfTopping.find_by_id(topping_type_id)
        toppings.each do |t|
          t.selection_info = OpenStruct.new(@toppings["topping-#{t.id}"])
        end
        
        if ["Sauces", "Cheeses"].include?(type_of_topping.name)
          normal_topping = toppings.find{|t| t.selection_info.preference == "Normal" && !t.normal_free? }
          light_topping = toppings.find{|t| t.selection_info.preference == "Light" && !t.light_free? }
          extra_topping = toppings.find{|t| t.selection_info.preference == "Extra" && !t.extra_free? }
          double_topping = toppings.find{|t| t.selection_info.preference == "Double"  && !t.double_free? }

          if normal_topping
            normal_topping.selection_info.price = 0.0
            normal_topping.selection_info.paid_toppings = 0
          elsif light_topping
            light_topping.selection_info.price = 0.0
            light_topping.selection_info.paid_toppings = 0
          elsif extra_topping
            extra_topping.selection_info.price = @pizza_size.normal_topping_price * 0.5
            extra_topping.selection_info.paid_toppings = 1
          elsif double_topping
            double_topping.selection_info.price = @pizza_size.normal_topping_price * 0.9
            double_topping.selection_info.paid_toppings = 2
          end
          
          toppings.each do |t|
            topping_preference = t.selection_info.preference.downcase
            t.selection_info.price ||= t.send("#{topping_preference}_free?") ? 0.0 : case topping_preference
            when "normal"
              @pizza_size.normal_topping_price * 1.0
            when "light"
              @pizza_size.normal_topping_price * 1.0
            when "extra"
              @pizza_size.normal_topping_price * 1.5
            when "double"
              @pizza_size.normal_topping_price * 1.9
            end
          end
        end

        toppings.each do |t|
          topping_preference = t.selection_info.preference.downcase
          t.selection_info.price ||= t.send("#{topping_preference}_free?") ? 0.0 : @pizza_size.send("#{topping_preference}_topping_price") 
          t.selection_info.paid_toppings ||= t.send("#{topping_preference}_free?") ? 0 : case topping_preference
          when "normal"
            1
          when "light" 
            1
          when "extra"
            2
          when "double"
            3
          end
          one_side_topping = t.selection_info.position != "Whole Pizza"
          if one_side_topping
            t.selection_info.price = t.selection_info.price / 2.0
          end
          if t.half_price_topping && !t.free_topping
            t.selection_info.price = t.selection_info.price / 2.0
          end
        end
      end
      all_toppings = Topping.all
      odd_number_of_one_sided_toppings = @toppings.values.select{|t| 
        t['position'] != "Whole Pizza" && t['selected'] && !all_toppings.find{|topping| topping.id.to_s == t['id'].to_s }.try(:free_topping)
      }.count % 2 != 0
      if odd_number_of_one_sided_toppings
        last_toppings_selected = @toppings_ar.select{|t| t.selection_info.position != "Whole Pizza" && t.selection_info.price > 0 }.last
        last_toppings_selected.selection_info.price += @pizza_size.normal_topping_price.to_f / 2.0 if last_toppings_selected
      end

      #For Combo Product 
      @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
      if @pizza_preset.present? && @pizza_preset.is_product_combo
        @product_combo = ProductCombo.find_by_id(@pizza_preset.product_combo_id)
        
        if self.order_id.present?
          num_of_free_toppings = !self.order.for_pickup? && @product_combo.title === "Pickup Special" ? 0 : @product_combo.no_of_toppings_on_each_pizza.to_i
        else
          num_of_free_toppings = @pizza_preset.is_product_combo ? @product_combo.no_of_toppings_on_each_pizza.to_i : 0
        end
        num_paid_toppings = @toppings_ar.map(&:selection_info).map(&:paid_toppings).reject(&:blank?).sum
        if num_paid_toppings <= num_of_free_toppings
          self.num_paid_toppings = 0
          return 0
        else
          self.num_paid_toppings = @toppings_ar.map(&:selection_info).map(&:paid_toppings).reject(&:blank?).sum - num_of_free_toppings
          pepperoni_discount = 0
          if self.deal_id.present?
            pepperoni_discount = @pizza_size.normal_topping_price * 1.9
          end
          return (@toppings_ar.map(&:selection_info).map(&:price).reject(&:blank?).sum - @pizza_size.normal_topping_price * num_of_free_toppings) - pepperoni_discount
        end
      else
        self.num_paid_toppings = @toppings_ar.map(&:selection_info).map(&:paid_toppings).reject(&:blank?).sum
        return @toppings_ar.map(&:selection_info).map(&:price).reject(&:blank?).sum
      end
      # self.num_paid_toppings = @toppings_ar.map(&:selection_info).map(&:paid_toppings).reject(&:blank?).sum
      # return @toppings_ar.map(&:selection_info).map(&:price).reject(&:blank?).sum
    end


    if self.product_info['product_type'] == "calzone"
      @calzone_preset = CalzonePreset.find_by_id(self.product_info['calzone_preset_id'])
      base_price = @calzone_preset.price
      topping_running_total = 0
      first_sauce_free = true
      first_cheese_free = true
    
      @toppings = self.product_info['toppings']
      
      @toppings_ar = Topping.where(id: @toppings.values.map{|t| t["id"] if t["selected"] } ).reject(&:nil?)
      @toppings_ar.group_by(&:type_of_topping_id).each do |topping_type_id, toppings|

        type_of_topping = TypeOfTopping.find_by_id(topping_type_id)
        toppings.each do |t|
          t.selection_info = OpenStruct.new(@toppings["topping-#{t.id}"])
        end
        
        if ["Sauces", "Cheeses"].include?(type_of_topping.name)
          normal_topping = toppings.find{|t| t.selection_info.preference == "Normal" && !t.normal_free? }
          light_topping = toppings.find{|t| t.selection_info.preference == "Light" && !t.light_free? }
          extra_topping = toppings.find{|t| t.selection_info.preference == "Extra" && !t.extra_free? }
          double_topping = toppings.find{|t| t.selection_info.preference == "Double"  && !t.double_free? }

          if normal_topping
            normal_topping.selection_info.price = 0.0
            normal_topping.selection_info.paid_toppings = 0
          elsif light_topping
            light_topping.selection_info.price = 0.0
            light_topping.selection_info.paid_toppings = 0
          elsif extra_topping
            extra_topping.selection_info.price = @calzone_preset.normal_topping_price * 0.5
            extra_topping.selection_info.paid_toppings = 1
          elsif double_topping
            double_topping.selection_info.price = @calzone_preset.normal_topping_price * 0.9
            double_topping.selection_info.paid_toppings = 2
          end

          toppings.each do |t|
            topping_preference = t.selection_info.preference.downcase
            t.selection_info.price ||= t.send("#{topping_preference}_free?") ? 0.0 : case topping_preference
            when "normal"
              @calzone_preset.normal_topping_price * 1.0
            when "light"
              @calzone_preset.normal_topping_price * 1.0
            when "extra"
              @calzone_preset.normal_topping_price * 1.5
            when "double"
              @calzone_preset.normal_topping_price * 1.9
            end
          end
        end

        toppings.each do |t|
          topping_preference = t.selection_info.preference.downcase
          t.selection_info.price ||= t.send("#{topping_preference}_free?") ? 0.0 : @calzone_preset.send("#{topping_preference}_topping_price")
          t.selection_info.paid_toppings ||= t.send("#{topping_preference}_free?") ? 0 : case topping_preference
          when "normal"
            1
          when "light" 
            1
          when "extra"
            2
          when "double"
            3
          end
        end
      end


      self.num_paid_toppings = @toppings_ar.map(&:selection_info).map(&:paid_toppings).reject(&:blank?).sum
      return @toppings_ar.map(&:selection_info).map(&:price).reject(&:blank?).sum
      
      
    end
    
  end

  def pizza_base_price_for_deal(product_combo)
    case self.pizza_position
      when 1
        product_combo.first_pizza_base_price.to_f
      when 2
        product_combo.second_pizza_base_price.to_f
      when 3
        product_combo.third_pizza_base_price.to_f
    else
        product_combo.first_pizza_base_price.to_f
    end
  end
  
  def price
    
    if self.product_info
      if self.product_info['product_type'] == "pizza"
        # get pricing info from the DB based on the pizza size
        @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titlecase).first
       
        # basic price of the pizza based on size
        
        @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
        
        if @pizza_preset.present? && @pizza_preset.is_product_combo
          @product_combo = ProductCombo.find_by_id(@pizza_preset.product_combo_id)
          if self.deal_id.present?
            base_price = self.pizza_base_price_for_deal(@product_combo)
          else
            if self.order_id.present?
              base_price = !self.order.for_pickup? && @product_combo.title === "Pickup Special" ? @pizza_size.price : @product_combo.combo_base_price.to_f
            else
              base_price = @pizza_preset.is_product_combo ? @product_combo.combo_base_price.to_f : @pizza_size.price 
            end
          end
        elsif self[:product_info]["pizza_size"] === "10_inches" && self[:product_info]["product_name"] != "Create Your Own Pizza" && self.is_catering 
          base_price = TEN_INCH_PIZZA_PRICE
        else 
          base_price = @pizza_size.price 
        end
        
        # topping price (based on the size fo the pizza)
        topping_price = @pizza_size.topping_price
        
        topping_price_running_total = 0
        
        topping_running_total = 0
        
        toppings_selected = 0
        
        topping_multiple = 0

        deep_dish_option_price = 0.0
      
        # calculate the total of the charagble toppings:
        puts "_______________#{self.num_paid_toppings}"
        #topping_price_running_total = self.num_paid_toppings * topping_price 
        topping_price_running_total = self.price_of_paid_toppings
          
        
        puts "---------------------------------------"
        puts self.id
        puts "There are #{self.num_paid_toppings} chargable toppings selected."
        
        
        # check for deep dish
        if self.product_info['pizza_crust_style']
          @pizza_crust_style = PizzaCrustStyle.where(:slug => self.product_info['pizza_crust_style']).first
          
          if @pizza_crust_style && @pizza_crust_style.deep_dish_pricing?
            puts "It's deep dish!"
            base_price += @pizza_size.deep_dish_option_price
            deep_dish_option_price = @pizza_size.deep_dish_option_price
          end
        end
        
        puts "---------------------------------------"
        
        # get the price of the order itme as a line item...
        
        puts "Total price of line item = #{number_to_currency(base_price + topping_price_running_total)}"
      
        final_price = base_price + topping_price_running_total + combo_additional_items_price
        puts "Final Price = #{final_price}, Base Price = #{base_price}" 
        if @pizza_preset.present? && @pizza_preset.is_product_combo && @product_combo.present? && (@product_combo.title === "Pickup Special" || @product_combo.title === "Delivery Special")
          if final_price < base_price
            return base_price
          else
            return final_price
          end
        elsif self[:product_info]["pizza_size"] === "10_inches" && self[:product_info]["product_name"] != "Create Your Own Pizza" && self.is_catering 
          return TEN_INCH_PIZZA_PRICE
        else 
          return final_price
        end
        # if order != nil && self.pickup_special? && order.for_pickup?
        #   return self.calculate_pickup_special_pricing_without_quantity + deep_dish_option_price
        # else
        #   return base_price + topping_price_running_total + combo_additional_items_price
        # end
      end
      
      if self.product_info['product_type'] == "calzone"
        
        @calzone_preset = CalzonePreset.find_by_id(self.product_info['calzone_preset_id'])
        base_price = @calzone_preset.price
        topping_price = @calzone_preset.topping_price
        
        topping_price_running_total = 0
        
        topping_running_total = 0
        
        toppings_selected = 0
        
        
        # output the total number of toppings based on the rounding math...
        puts "There are the equivelent of #{topping_running_total} topping(s) selected, with a rounded up figure of #{topping_running_total.ceil} topping(s) "
        
        # calculate the total of the charagble toppings:
        #topping_price_running_total = self.num_paid_toppings * topping_price
        topping_price_running_total = self.price_of_paid_toppings
        
        # get the price of the order itme as a line item...

        puts "Total price of line item = #{number_to_currency(base_price + topping_price_running_total)}"

        return base_price + topping_price_running_total
        
      end
    else 
      return 0
    end
    
  end
  

  def combo_additional_items_price

    @pizza_preset = PizzaPreset.find_by_id(self.product_info["pizza_preset_id"])
    if @pizza_preset.present? && @pizza_preset.is_product_combo
      @product_combo = ProductCombo.find_by_id(@pizza_preset.product_combo_id)

      if self.order_id.present? && !self.order.for_pickup? && @product_combo.title == "Pickup Special"
        return 0
      end
      
      #self.product_info["order_additional"]
      #@product_combo.no_of_free_additional_items
      if self.product_info["order_additional"].present? && self.product_info["order_additional"].count > 0
        total_number_of_additional_item_in_combo = 0
        additional_item_in_combo = []
        self.product_info["order_additional"].each do |k,v|
          if k === "dipping_sauces" && v.count > 0
              v.each do |ds|
                if ds[1].to_i > 0
                  total_number_of_additional_item_in_combo += ds[1].to_i
                  additional_item_in_combo.push(
                    {
                      name: ApplicationController.helpers.get_dipping_sauce_name(ds[0]),
                      id: ds[0].gsub(/[^0-9]/i, '').to_i,
                      type: "dipping_sauce",
                      price: ApplicationController.helpers.get_dipping_sauce_price(ds[0]).to_f,
                      quantity: ds[1].to_i
                    }
                  )
                end
              end  
          end
          if k === "beverages" && v.count > 0
            v.each do |be|
              if be[1].to_i > 0
                total_number_of_additional_item_in_combo += be[1].to_i
                additional_item_in_combo.push(
                  {
                    name: ApplicationController.helpers.get_beverage_name(be[0]),
                    id: be[0].gsub(/[^0-9]/i, '').to_i,
                    type: "beverage",
                    price: ApplicationController.helpers.get_beverage_price(be[0]).to_f,
                    quantity: be[1].to_i
                  }
                )
              end
            end  
          end
          if k === "salads" && v.count > 0
            v.each do |sa|
              if sa[1].to_i > 0
                total_number_of_additional_item_in_combo += sa[1].to_i
                additional_item_in_combo.push(
                  {
                    name: ApplicationController.helpers.get_salad_name(sa[0]),
                    id: sa[0].gsub(/[^0-9]/i, '').to_i,
                    type: "salad",
                    price: ApplicationController.helpers.get_salad_price_normal(sa[0]).to_f,
                    quantity: sa[1].to_i
                  }
                )
              end
            end  
          end
          if k === "garlic_breads" && v.count > 0
            v.each do |gb|
              if gb[1].to_i > 0
                total_number_of_additional_item_in_combo += gb[1].to_i
                additional_item_in_combo.push(
                  {
                    name: ApplicationController.helpers.get_garlic_bread_name(gb[0]),
                    id: gb[0].gsub(/[^0-9]/i, '').to_i,
                    type: "garlic_bread",
                    price: ApplicationController.helpers.get_dipping_sauce_price_normal(gb[0]).to_f,
                    quantity: gb[1].to_i
                  }
                )
              end
            end  
          end
        end

        if total_number_of_additional_item_in_combo > 0 && total_number_of_additional_item_in_combo > @product_combo.no_of_free_additional_items
          no_of_free_additional_items = @product_combo.no_of_free_additional_items
          price_of_free_additional_items = 0
          additional_item_in_combo.sort_by { |hsh| hsh[:price] }.each do |ai|
            if ai[:quantity] == no_of_free_additional_items
              no_of_free_additional_items = 0
            elsif ai[:quantity] < no_of_free_additional_items
              no_of_free_additional_items = no_of_free_additional_items - ai[:quantity]
            elsif ai[:quantity] > no_of_free_additional_items
              quantity = ai[:quantity] - no_of_free_additional_items
              no_of_free_additional_items = 0
              price_of_free_additional_items += quantity * ai[:price]
            else
              price_of_free_additional_items += ai[:quantity] * ai[:price]
            end
          end
          return price_of_free_additional_items.to_f
        else
          return 0
        end
       
      else
        return 0
      end
      #base_price = @pizza_preset.is_product_combo ? @product_combo.combo_base_price.to_f : @pizza_size.price 
      
    else
      return 0
    end
  end
  
  # def price
  #   if self.product_info
  #     if self.product_info['product_type'] == "pizza"
        
  #       # get pricing info from the DB based on the pizza size
  #       @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titlecase).first
        
  #       # basic price of the pizza based on size
  #       base_price = @pizza_size.price
        
  #       # topping price (based on the size fo the pizza)
  #       topping_price = @pizza_size.topping_price
        
  #       topping_price_running_total = 0
        
  #       topping_running_total = 0
        
  #       toppings_selected = 0
        
  #       topping_multiple = 0
      
  #       # calculate the total of the charagble toppings:
  #       topping_price_running_total = self.num_paid_toppings * topping_price 
        
        
  #       puts "---------------------------------------"
  #       puts self.id
  #       puts "There are #{self.num_paid_toppings} chargable toppings selected."
        
        
  #       # check for deep dish
  #       if self.product_info['pizza_crust_style']
          
  #         @pizza_crust_style = PizzaCrustStyle.where(:name => self.product_info['pizza_crust_style'].titlecase).first
          
  #         if @pizza_crust_style && @pizza_crust_style.deep_dish_pricing?
  #           puts "It's deep dish!"
  #           base_price += @pizza_size.deep_dish_option_price
  #         end
  #       end
        
  #       puts "---------------------------------------"
        
  #       # get the price of the order itme as a line item...
        
  #       puts "Total price of line item = #{number_to_currency(base_price + topping_price_running_total)}"
      
  #       if order != nil && self.pickup_special? && order.for_pickup?
  #         return self.calculate_pickup_special_pricing_without_quantity
  #       else
  #         return base_price + topping_price_running_total
  #       end
  #     end
      
  #     if self.product_info['product_type'] == "calzone"
        
  #       @calzone_preset = CalzonePreset.find(self.product_info['calzone_preset_id'])
  #       base_price = @calzone_preset.price
  #       topping_price = @calzone_preset.topping_price
        
  #       topping_price_running_total = 0
        
  #       topping_running_total = 0
        
  #       toppings_selected = 0
        
        
  #       # output the total number of toppings based on the rounding math...
  #       puts "There are the equivelent of #{topping_running_total} topping(s) selected, with a rounded up figure of #{topping_running_total.ceil} topping(s) "
        
  #       # calculate the total of the charagble toppings:
  #       topping_price_running_total = self.num_paid_toppings * topping_price
        
  #       # get the price of the order itme as a line item...
  #       puts "Total price of line item = #{number_to_currency(base_price + topping_price_running_total)}"
  #       return base_price + topping_price_running_total
        
  #     end
  #   else 
  #     return 0
  #   end
    
  # end
  
  def price_formatted
    number_to_currency(self.price)
  end

  def price_formatted_with_quantity
    number_to_currency(self.price * self.quantity.to_i)
  end
  
  def toppings_arr
    toppings_arr = []
    @toppings = self.product_info['toppings']
    @toppings.each do |t|
      if t[1]["selected"]
       
        topping_arr = []
        topping_arr << t[1]['name'] + ": "
        topping_arr << t[1]['preference'] + " / "
        topping_arr << t[1]['position']
        toppings_arr << topping_arr
      end
    end
    
    return toppings_arr
    
  end
  
  # ---------------------------------------------------
  # ---------------- FOR THE PRINTER ------------------
  
  def order_additional_print_arr
    pizza_preset_id = self.product_info['pizza_preset_id']
    pizza_preset = PizzaPreset.find_by_id(pizza_preset_id)
    items = []
    items_for_free_count = 0
    if pizza_preset && pizza_preset.is_product_combo && self.product_info["order_additional"]
      no_of_free_additional_items = pizza_preset.product_combo.no_of_free_additional_items
      dipping_sauce_count = self.product_info["order_additional"]['dipping_sauces'].values.map(&:to_f).sum
      beverage_count = self.product_info["order_additional"]['beverages'].values.map(&:to_f).sum
      self.product_info["order_additional"]['dipping_sauces'].each do |dipping_sauce| 
        dipping_sauce_name = ApplicationController.helpers.get_dipping_sauce_name(dipping_sauce[0])
        dipping_sauce_count = dipping_sauce[1].to_i
        if dipping_sauce_count > 0 && dipping_sauce[1].to_f <= no_of_free_additional_items && items_for_free_count <= 1
          items_for_free_count += dipping_sauce_count
          items.push({
            label: dipping_sauce_name,
            qty: dipping_sauce_count,
            price: 0
          })
        elsif dipping_sauce_count > 0 && dipping_sauce[1].to_f > no_of_free_additional_items && items_for_free_count <= 1
          items_for_free_count += dipping_sauce_count
          items.push({
            label: dipping_sauce_name,
            qty: no_of_free_additional_items,
            price: 0
          })
          items.push({
            label: dipping_sauce_name,
            qty: dipping_sauce_count - no_of_free_additional_items,
            price: ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0], 1)
          })
        elsif dipping_sauce_count > 0
          items.push({
            label: dipping_sauce_name,
            qty: dipping_sauce_count,
            price: ApplicationController.helpers.get_dipping_sauce_price_total(dipping_sauce[0], 1)
          })
        end
      end
      self.product_info["order_additional"]['beverages'].each do |beverage|
        beverage_name = ApplicationController.helpers.get_beverage_name(beverage[0])
        beverage_count = beverage[1].to_i
        if beverage_count > 0 && beverage[1].to_f <= no_of_free_additional_items && items_for_free_count <= 1
          items_for_free_count += beverage_count
          items.push({
            label: beverage_name,
            qty: beverage_count,
            price: 0
          })
        elsif beverage_count > 0 && beverage[1].to_f > no_of_free_additional_items && items_for_free_count <= 1
          items_for_free_count += beverage_count
          items.push({
            label: beverage_name,
            qty: no_of_free_additional_items,
            price: 0
          })
          items.push({
            label: beverage_name,
            qty: beverage_count - no_of_free_additional_items,
            price: ApplicationController.helpers.get_beverage_price(beverage[0])
          })
        elsif beverage_count > 0
          items.push({
            label: beverage_name,
            qty: beverage_count,
            price: ApplicationController.helpers.get_beverage_price(beverage[0])
          })
        end
      end
    end
    items
  end
  
  def toppings_print_arr(position)
    
    case position
    when "left"
      ref_position = "Left Side"
    when "right"
      ref_position = "Right Side"
    else
      ref_position = "Whole Pizza"
    end
    
    toppings_arr = []
    @toppings = self.product_info['toppings']
    # @toppings = @toppings.sort_by {|topping| topping.last['type']}
    @toppings.sort_by {|topping| topping.last['type']}.each do |t|
      
      if t[1]["selected"] && t[1]["position"] == ref_position
       
        topping_arr = []
        
        @topping = Topping.find_by_id(t[1]["id"])   
        topping_name = @topping.print_name.present? ? ActionView::Base.full_sanitizer.sanitize(@topping.print_name) : ActionView::Base.full_sanitizer.sanitize(@topping.name)
        topping_arr << topping_name
        
        if t[1]['preference'] == "Normal"
          topping_arr << ""
          topping_arr << ""
          
        else
          if @topping && @topping.count_as_double === true && t[1]['preference'] === 'Extra'
            topping_arr << ""
            topping_arr << ""
          else
            divider = ".........................................."
            total_width_chars = 39
            
            name_length = t[1]['name'].length
            pref_length = t[1]['preference'].length
            
            divider_length = total_width_chars - name_length - pref_length
            
            divider_concat = " #{divider.to(divider_length)} "
            
            topping_arr << divider_concat
            topping_arr << t[1]['preference']
          end
        
        end
        toppings_arr << topping_arr
      end
    end
    
    return toppings_arr
    
  end
  
  def toppings_calzone_print_arr
    
    toppings_arr = []
    @toppings = self.product_info['toppings']
    @toppings.each do |t|
      if t[1]["selected"]
        topping_arr = []
        topping_arr << t[1]['name']
        unless t[1]['preference'] == "Normal"
          
          divider = ".........................................."
          total_width_chars = 39
          
          name_length = t[1]['name'].length
          pref_length = t[1]['preference'].length
          
          divider_length = total_width_chars - name_length - pref_length
          
          divider_concat = " #{divider.to(divider_length)} "
          
          topping_arr << divider_concat
          topping_arr << t[1]['preference']
          
        else
          topping_arr << ""
          topping_arr << ""
        end
        toppings_arr << topping_arr
      end
    end
    
    return toppings_arr
    
  end
  
    
  # ---------------- END FOR THE PRINTER -----------------
  # ------------------------------------------------------
  
  
  def pizza_size_long_form
    @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titleize).first
    return @pizza_size.external_name
  end
  
  def pizza_size_short_form
    @pizza_size = PizzaSize.where(:name => self.product_info['pizza_size'].titleize).first
    return @pizza_size.abbr_name
  end
  
  
  
  
  def custom
    
    custom = false
    
    if self.product_info['product_type'] == "pizza"
      
      @preset = PizzaPreset.find_by_id(self.product_info['pizza_preset_id'].to_i) || PizzaPreset.find_by_product_name(self.product_info['product_name'].to_i)
      
      # if the pizza has been made Gluten Free from a normal base...
      if @preset.product_info['pizza_size'].include?("gluten-free") != self.product_info['pizza_size'].include?("gluten-free")
        puts "the main pizza is not the same base..."
        custom = true
      end
      
      # if the toppings are different differently to the original...
      if self.product_info['toppings'].sort.to_s != @preset.product_info['toppings'].sort.to_s
        puts "toppings are different..."
        custom = true
      end
      
      # if the crust and or style are different...
      if self.product_info['pizza_crust'] != @preset.product_info['pizza_crust'] || self.product_info['pizza_crust_style'] != @preset.product_info['pizza_crust_style']
        puts "crust or style are different..."
        custom = true
      end
      
      if @preset.present? && @preset.is_product_combo
        custom = false
      end
    end
    
    if self.product_info['product_type'] == "calzone"
      @preset = CalzonePreset.find_by_id(self.product_info['calzone_preset_id'].to_i)
      if self.product_info['toppings'].diff(@preset.product_info['toppings'])
        custom = true
      end
    end
    
    return custom
    
  end

  def show_upsize
    if self.product_info.present?
      if self.product_info['pizza_size'] == "gluten-free-small"
        return true
      elsif self.product_info['pizza_size'] == "gluten-free"
        return false
      elsif self.product_info['pizza_size'] == "cauliflower-s"
        return true
      elsif self.product_info['pizza_size'] == "cauliflower-m"
        return false
      elsif self.product_info['pizza_size'] == "medium"
        return true
      elsif self.product_info['pizza_size'] == "large"
        return true
      elsif self.product_info['pizza_size'] == "xlarge"
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def next_size
    if self.product_info.present?
      if self.product_info['pizza_size'] == "gluten-free-small"
        return "gluten-free"
      elsif self.product_info['pizza_size'] == "cauliflower-s"
        return "cauliflower-m"
      elsif self.product_info['pizza_size'] == "medium"
        return "Large"
      elsif self.product_info['pizza_size'] == "large"
        return "XLarge"
      elsif self.product_info['pizza_size'] == "xlarge"
        return "Party"
      else 
        return ""
      end
    else
      return ""
    end
  end

  def next_size_short
    if self.product_info['pizza_size'] == "gluten-free-small"
      return "LG"
    elsif self.product_info['pizza_size'] == "cauliflower-s"
      return "CM"
    elsif self.product_info['pizza_size'] == "medium"
      return "LG"
    elsif self.product_info['pizza_size'] == "large"
      return "XL"
    elsif self.product_info['pizza_size'] == "xlarge"
      return "PARTY"
    else 
      return ""
    end
  end

  def pizza_size_difference
    if self.product_info['pizza_size'] == "gluten-free-small"
      current_size_prize = get_pizza_size_price("gluten-free-small", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "large"
      next_size_prize = get_pizza_size_price("gluten-free", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "gluten-free-small"
      differance = (next_size_prize - current_size_prize).to_f
      return number_to_currency(differance)
    elsif self.product_info['pizza_size'] == "cauliflower-s"
      current_size_prize = get_pizza_size_price("cauliflower-s", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "cauliflower-m"
      next_size_prize = get_pizza_size_price("cauliflower-m", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "cauliflower-s"
      differance = (next_size_prize - current_size_prize).to_f
      return number_to_currency(differance)
    elsif self.product_info['pizza_size'] == "medium"
      current_size_prize = get_pizza_size_price("medium", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "large"
      next_size_prize = get_pizza_size_price("large", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "medium"
      differance = (next_size_prize - current_size_prize).to_f
      return number_to_currency(differance)
    elsif self.product_info['pizza_size'] == "large"
      current_size_prize = get_pizza_size_price("large", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "xlarge"
      next_size_prize = get_pizza_size_price("xlarge", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      self.product_info['pizza_size'] = "large"
      differance = (next_size_prize - current_size_prize).to_f
      return number_to_currency(differance)
    elsif self.product_info['pizza_size'] == "xlarge"
      current_size_prize = get_pizza_size_price("xlarge", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      next_size_prize = get_pizza_size_price("party", self.product_info['pizza_preset_id'], self.product_info['pizza_crust_style']).to_f
      differance = (next_size_prize - current_size_prize).to_f
      return number_to_currency(differance)
    else 
      return 0.0
    end
  end


  def get_pizza_size_price(current_size, pizza_preset_id, pizza_crust_style)
    
    if current_size
      # get pricing info from the DB based on the pizza size
      @pizza_size = PizzaSize.where(:name => current_size.titlecase).first
       
        # basic price of the pizza based on size
        
        @pizza_preset = PizzaPreset.find_by_id(pizza_preset_id)
        
        if @pizza_preset.present? && @pizza_preset.is_product_combo
          @product_combo = ProductCombo.find_by_id(@pizza_preset.product_combo_id)
          base_price = @pizza_preset.is_product_combo ? @product_combo.combo_base_price.to_f : @pizza_size.price 
        else
          base_price = @pizza_size.price 
        end
        
        # topping price (based on the size fo the pizza)
        topping_price = @pizza_size.topping_price
        
        topping_price_running_total = 0
        
        topping_running_total = 0
        
        toppings_selected = 0
        
        topping_multiple = 0

        deep_dish_option_price = 0.0
      
        # calculate the total of the charagble toppings:
        puts "_______________#{self.num_paid_toppings}"
        #topping_price_running_total = self.num_paid_toppings * topping_price 
        topping_price_running_total = self.price_of_paid_toppings
          
        
        puts "---------------------------------------"
        puts self.id
        puts "There are #{self.num_paid_toppings} chargable toppings selected."
        
        
        # check for deep dish
        if self.product_info['pizza_crust_style']
          
          @pizza_crust_style = PizzaCrustStyle.where(:slug => pizza_crust_style).first
          
          if @pizza_crust_style && @pizza_crust_style.deep_dish_pricing?
            puts "It's deep dish!"
            base_price += @pizza_size.deep_dish_option_price
            deep_dish_option_price = @pizza_size.deep_dish_option_price
          end
        end
        
        puts "---------------------------------------"
        
        # get the price of the order itme as a line item...
        
        puts "Total price of line item = #{number_to_currency(base_price + topping_price_running_total)}"
      
        return base_price + topping_price_running_total + combo_additional_items_price

    else 
      return 0
    end
    
  end

  def show_downsize
    if self.product_info['pizza_size'] == "gluten-free"
      return true
    elsif self.product_info['pizza_size'] == "large"
      return true
    elsif self.product_info['pizza_size'] == "xlarge"
      return true
    elsif self.product_info['pizza_size'] == "party"
      return true
    else
      return false
    end
  end

  def next_downsize
    if self.product_info['pizza_size'] == "gluten-free"
      return "gluten-free-small"
    elsif self.product_info['pizza_size'] == "large"
      return "medium"
    elsif self.product_info['pizza_size'] == "xlarge"
      return "large"
    elsif self.product_info['pizza_size'] == "party"
      return "xlarge"
    else 
      return self.product_info['pizza_size'] # no change
    end
  end

  def print_title
    
    print_title = self.product_info['product_name']
    
    if self.product_info['product_type'] == "pizza"
      
      @preset = PizzaPreset.find_by_id(self.product_info['pizza_preset_id'].to_i)
      
      # # if the toppings are the same as original
      # if self.toppings.sort.to_s == @preset.toppings.sort.to_s
      #   puts "toppings are the same..."
      #   print_title = self.product_info['product_name']
      # end

      # if the pizza has been made Gluten Free from a normal base...
      if @preset.product_info['pizza_size'].include?("gluten-free") != self.product_info['pizza_size'].include?("gluten-free")
        puts "the main pizza is not the same base..."
        print_title = print_title + " - Gluten Free"
      end
      
      # if the toppings are different differently to the original...
      if self.toppings.sort.to_s != @preset.toppings.sort.to_s
        puts "toppings are different..."
        print_title = print_title + " - Custom Toppings"
      end

      # if it's a totally Custom Pizza
      # if self.product_info['pizza_preset_id'].to_i == PizzaCategory.find(4).pizza_presets.first.id
      #   puts "Custom Pizza preset"
      #   print_title = self.product_info['product_name']
      # end
      
      # if the crust and or style are different...
      if self.product_info['pizza_crust'] != @preset.product_info['pizza_crust'] || self.product_info['pizza_crust_style'] != @preset.product_info['pizza_crust_style']
        puts "crust or style are different..."
        print_title = print_title + " - Custom Crust"
      end

    end
    
    if self.product_info['product_type'] == "calzone"
      @preset = CalzonePreset.find_by_id(self.product_info['calzone_preset_id'].to_i)
      if self.product_info['toppings'].diff(@preset.product_info['toppings'])
        print_title = "Baked Calzone - Custom"
      end
    end
    
    return print_title
    
  end

  def pickup_special?
    self.product_info.present? && self.product_info['product_type'] === 'pizza' && (self.product_info['pizza_size'] == 'large' ||  self.product_info['pizza_size'] == 'medium' || self.product_info['pizza_size'] == 'xlarge') && self.num_paid_toppings === 2
  end

  def pickup_special_pricing
     self.pickup_special? ? self.calculate_pickup_special_pricing : regular_pricing
  end

  def calculate_pickup_special_pricing
    case self.product_info['pizza_size']
      when "medium"
        12.99 * self.quantity.to_i 
      when "large"
        14.99 * self.quantity.to_i 
      when "xlarge"
        18.99 * self.quantity.to_i 
    end
  end

  def calculate_pickup_special_pricing_without_quantity
    case self.product_info['pizza_size']
      when "medium"
        12.99 
      when "large"
        14.99 
      when "xlarge"
        18.99 
    end
  end

  def regular_pricing
    self.price * self.quantity.to_i
  end

  # def update_special_price
  #   case self.product_info['pizza_size']
  #     when "medium"
  #       12.99
  #     when "large"
  #       14.99
  #     when "xlarge"
  #       18.99
  #   end
  # end

end
