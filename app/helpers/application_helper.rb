
module ApplicationHelper
  
  # GEO-Caching
  
  def geo_code(postcode, address=nil)

    if postcode.blank?
      return nil
    end

    # remove spaces and such from the postal code
    postcode_to_save_and_check = postcode.downcase.delete(' ')
    
    # check to see if it exists in the database
    @post_code = PostCode.where(:postcode => postcode_to_save_and_check).first
    
    if @post_code && @post_code.updated_at > 90.days.ago
      # use the postal code from the database
      return [@post_code.latitude.to_f, @post_code.longitude.to_f]
    else
      # lookup via Google
      loc = Geocoder.coordinates(postcode_to_save_and_check) || Geocoder.coordinates(address)
      if loc.nil?
        # could not geocode location
        return nil
      else
        # geocoding location ...
        # Create new postalcode record
        @post_code = PostCode.find_by_postcode(postcode_to_save_and_check) || PostCode.new(:postcode => postcode_to_save_and_check)
        if @post_code.update_attributes(:latitude => loc[0], :longitude => loc[1])
          # Found location and added to DB
          return [@post_code.latitude.to_f, @post_code.longitude.to_f]
        else
          # Could not geocode location OR problem savin to the database
          return nil
        end
      end
    end
    
  end
  
  # PRINTING
  
  def print_format_keypair(item1,item2)
    divider = "                                          "
    total_width_chars = 39
    divider_length = total_width_chars - item1.length - item2.length
    divider_concat = " #{divider.to(divider_length)} "
    return "#{item1}#{divider_concat}#{item2}"
  end

  def print_format_keypair_with_divider(item1,item2)
    divider = ".........................................."
    total_width_chars = 39
    divider_length = total_width_chars - item1.length - item2.length
    divider_concat = " #{divider.to(divider_length)} "
    return "#{item1}#{divider_concat}#{item2}"
  end
  
  def email_format_keypair(item1,item2)
    return "#{item1} #{item2}"
  end

  def bold_text_for_print(data)
    Escpos::Helpers.bold(data)
  end
  
  # BEVERAGES
  def get_beverage_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    "#{Beverage.find_by_id(id.to_i).name} #{Beverage.find_by_id(id.to_i).extra_info ? "(#{Beverage.find_by_id(id.to_i).extra_info})" : ''} " if Beverage.exists?(id.to_i) 
  end
  
  def get_beverage_price(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    Beverage.find_by_id(id.to_i).try(:price)
  end
  
  def get_beverage_price_total(id_name,num)
    id = id_name.gsub(/[^0-9]/i, '')
    Beverage.find_by_id(id.to_i).try(:price).to_f * num.to_i
  end
  
  
  
  
  # DESSERTS
  def get_dessert_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    Dessert.find_by_id(id.to_i).name if Dessert.exists?(id.to_i)
  end
  
  def get_dessert_price(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    Dessert.find_by_id(id.to_i).try(:price)
  end
  
  def get_dessert_price_total(id_name,num)
    id = id_name.gsub(/[^0-9]/i, '')
    Dessert.find_by_id(id.to_i).try(:price).to_f * num.to_i
  end
  
  
  # UTENSILS
  def get_utensil_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    Utensil.find_by_id(id.to_i).name if Utensil.exists?(id.to_i)
  end
  
  
  
  # DIPPING SAUCES
  def get_dipping_sauce_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    DippingSauce.find_by_id(id.to_i).name if DippingSauce.exists?(id.to_i)
  end
  
  def get_dipping_sauce_price(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    DippingSauce.find_by_id(id.to_i).try(:price)
  end
  
  def get_dipping_sauce_price_total(id_name,num)
    id = id_name.gsub(/[^0-9]/i, '')
    DippingSauce.find_by_id(id.to_i).try(:price).to_f * num.to_i
  end
  
  
  # GARLIC BREADS

  def get_garlic_bread_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    "#{GarlicBread.find(id.to_i).name} #{GarlicBread.find(id.to_i).extra_info ? "(#{GarlicBread.find(id.to_i).extra_info})" : ''} " if GarlicBread.exists?(id.to_i) 
     
  end
  
  def get_dipping_sauce_price_normal(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    GarlicBread.find_by_id(id.to_i).try(:price)
  end

  def get_garlic_bread_price(order,id_name,num=nil)
    
    @order = order
    
    id = id_name.gsub(/[^0-9]/i, '')

    
    if @order.order_additional.blank? || @order.order_additional['catering_order'] == "0"
      
      # get prices based on normal order
      GarlicBread.find(id.to_i).try(:price)
      
    else
    
      unless num
      case @order.order_additional['catering_order_group_number']
      when "1-5"
        GarlicBread.find(id.to_i).price_one_to_five
      when "6-19"
        GarlicBread.find(id.to_i).price_six_to_nineteen
      when "20+"
        GarlicBread.find(id.to_i).price_twenty_plus
      else
        GarlicBread.find(id.to_i).price
      end
    else
      case num.to_i
      when 1..5
        GarlicBread.find(id.to_i).price_one_to_five
      when 6..19
        GarlicBread.find(id.to_i).price_six_to_nineteen
      when 20..5000000
        GarlicBread.find(id.to_i).price_twenty_plus
      else
        GarlicBread.find(id.to_i).price
      end
    end
      
    end
    
  end

  def get_garlic_bread_price_total(order,id_name,num)
    
    @order = order
    
    id = id_name.gsub(/[^0-9]/i, '')
    
    if @order.order_additional.blank? || @order.order_additional['catering_order'] == "0"
      
      # get prices based on normal order
      GarlicBread.find(id.to_i).price * num.to_i
      
    else
      # puts " num.to_i=#{ num.to_i}"
      # case @order.order_additional['catering_order_group_number']
      # when "1-5"
      #   Salad.find(id.to_i).price_one_to_five * num.to_i
      # when "6-19"
      #   Salad.find(id.to_i).price_six_to_nineteen * num.to_i
      # when "20+"
      #   Salad.find(id.to_i).price_twenty_plus * num.to_i
      # else
      #   Salad.find(id.to_i).price * num.to_i
      # end
      
      case num.to_i
      when 1..5
        GarlicBread.find(id.to_i).price_one_to_five * num.to_i
      when 6..19
        GarlicBread.find(id.to_i).price_six_to_nineteen * num.to_i
      when 20..5000000
        GarlicBread.find(id.to_i).price_twenty_plus * num.to_i
      else
        GarlicBread.find(id.to_i).price * num.to_i
      end
      
    end
    
  end

  # CANNOLIS
  def get_cannoli_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    "#{Cannoli.find_by_id(id.to_i).name}" if Cannoli.exists?(id.to_i) 
  end

  def get_cannoli_price(order,id_name,num=nil)
    @order = order
    id = id_name.gsub(/[^0-9]/i, '')
    Cannoli.find_by_id(id.to_i).try(:price)
  end

  def get_cannoli_price_total(order,id_name,num)
    @order = order
    id = id_name.gsub(/[^0-9]/i, '')
    Cannoli.find_by_id(id.to_i).price * num.to_i
  end

  
  # SALADS
  def get_salad_name(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    Salad.find(id.to_i).name if Salad.exists?(id.to_i)
  end

  def get_salad_price_normal(id_name)
    id = id_name.gsub(/[^0-9]/i, '')
    Salad.find_by_id(id.to_i).try(:price)
  end
  
  def get_salad_price(order,id_name,num=nil)
    
    @order = order
    
    id = id_name.gsub(/[^0-9]/i, '')

    
    if @order.order_additional.blank? || @order.order_additional['catering_order'] == "0"
      
      # get prices based on normal order
      Salad.find(id.to_i).try(:price)
      
    else
    
      unless num
      case @order.order_additional['catering_order_group_number']
      when "1-5"
        Salad.find(id.to_i).price_one_to_five
      when "6-19"
        Salad.find(id.to_i).price_six_to_nineteen
      when "20+"
        Salad.find(id.to_i).price_twenty_plus
      else
        Salad.find(id.to_i).price
      end
    else
      case num.to_i
      when 1..5
        Salad.find(id.to_i).price_one_to_five
      when 6..19
        Salad.find(id.to_i).price_six_to_nineteen
      when 20..5000000
        Salad.find(id.to_i).price_twenty_plus
      else
        Salad.find(id.to_i).price
      end
    end
      
    end
    
    
  end
  
  
  def get_salad_price_total(order,id_name,num)
    
    @order = order
    
    id = id_name.gsub(/[^0-9]/i, '')
    
    if @order.order_additional.blank? || @order.order_additional['catering_order'] == "0"
      
      # get prices based on normal order
      Salad.find(id.to_i).price * num.to_i
      
    else
      # puts " num.to_i=#{ num.to_i}"
      # case @order.order_additional['catering_order_group_number']
      # when "1-5"
      #   Salad.find(id.to_i).price_one_to_five * num.to_i
      # when "6-19"
      #   Salad.find(id.to_i).price_six_to_nineteen * num.to_i
      # when "20+"
      #   Salad.find(id.to_i).price_twenty_plus * num.to_i
      # else
      #   Salad.find(id.to_i).price * num.to_i
      # end
      
      case num.to_i
      when 1..5
        Salad.find(id.to_i).price_one_to_five * num.to_i
      when 6..19
        Salad.find(id.to_i).price_six_to_nineteen * num.to_i
      when 20..5000000
        Salad.find(id.to_i).price_twenty_plus * num.to_i
      else
        Salad.find(id.to_i).price * num.to_i
      end
      
    end
    
  end
  
  
    
end
