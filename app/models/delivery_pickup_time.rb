class DeliveryPickupTime < ActiveRecord::Base
  
  
  def asap(order)
    
    @order = order
    
    day_reference = Time.now.strftime('%A').downcase[0..2]
    tomorrow_reference = Date.tomorrow.strftime('%A').downcase[0..2]
    
    puts day_reference
    
    time_now = Time.at((Time.now.to_f / 15.minutes).round * 15.minutes)
    
    puts "Current Time Rounded Up: #{time_now}"
      
    opening_time = @order.franchise_location.send("#{day_reference}_open")
    closing_time = @order.franchise_location.send("#{day_reference}_closed")
    
    opening_time_tomorrow = @order.franchise_location.send("#{tomorrow_reference}_open")
    closing_time_tomorrow = @order.franchise_location.send("#{tomorrow_reference}_closed")
    
    opening_time_hour = opening_time.strftime('%H')
    opening_time_minutes = opening_time.strftime('%M')
    closing_time_hour = closing_time.strftime('%H')
    closing_time_minutes = closing_time.strftime('%M')
    
    opening_time_tomorrow_hour = opening_time_tomorrow.strftime('%H')
    opening_time_tomorrow_minutes = opening_time_tomorrow.strftime('%M')
    closing_time_tomorrow_hour = closing_time_tomorrow.strftime('%H')
    closing_time_tomorrow_minutes = closing_time_tomorrow.strftime('%M')
    
    
    if @order.for_pickup?
      opening_time_offset = FRANCHISE_LOCATION_PICKUP_OFFSET
      closing_time_offset = FRANCHISE_LOCATION_PICKUP_OFFSET
    else
      opening_time_offset = FRANCHISE_LOCATION_DELIVERY_OFFSET
      closing_time_offset = FRANCHISE_LOCATION_DELIVERY_OFFSET
    end
    
    opening_time_calculated = Date.today + opening_time_hour.to_i.hours + opening_time_minutes.to_i.minutes + opening_time_offset
    
    if closing_time_hour.to_i < 12
      closing_time_calculated = Date.today + 24.hours + closing_time_hour.to_i.hours + closing_time_minutes.to_i.minutes - closing_time_offset
    else
      closing_time_calculated = Date.today + closing_time_hour.to_i.hours + closing_time_minutes.to_i.minutes - closing_time_offset
    end
    
    
    opening_time_tomorrow_calculated = Date.today + opening_time_tomorrow_hour.to_i.hours + opening_time_tomorrow_minutes.to_i.minutes + opening_time_offset
    
    if closing_time_tomorrow_hour.to_i < 12
      closing_time_tomorrow_calculated = Date.today + 24.hours + closing_time_tomorrow_hour.to_i.hours + closing_time_tomorrow_minutes.to_i.minutes - closing_time_offset
    else
      closing_time_tomorrow_calculated = Date.today + closing_time_tomorrow_hour.to_i.hours + closing_time_tomorrow_minutes.to_i.minutes - closing_time_offset
    end
    
    
    puts "opening-time: #{opening_time_calculated}"
    puts "closing-time: #{closing_time_calculated}"
    
    if !@order.order_additional.blank? && @order.order_additional['catering'] && @order.order_additional['catering'] == "1"
      
      # for CATERING
      
    else
      
      if time_now > opening_time_calculated && time_now < closing_time_calculated
        puts "can be ordered now, eta: #{time_now + opening_time_offset}"
        return {:asap => true, :eta => time_now + opening_time_offset}
      else
        
        puts "Have to be ordered tomorrow/later"
        
        # same day but later
        if time_now < closing_time_calculated
          eta = opening_time_calculated + opening_time_offset
          
        end
        
        #tomorrow at opening
        if time_now > closing_time_calculated
          eta = opening_time_tomorrow_calculated + opening_time_offset
        end
        
        return {:asap => false, :eta => eta}
        
      end
      
    end
    
  end
  
  
  
  
end


