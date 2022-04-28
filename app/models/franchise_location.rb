require 'securerandom'
class FranchiseLocation < ActiveRecord::Base
  CUTOFF_HOUR_FOR_LATE_NIGHT_LOCATIONS = 7

  extend FriendlyId
  friendly_id :address, use: :slugged

  before_save :add_api_key_and_store_id
  
  attr_accessible :active, :address, :address_details, :area_name, :fri_closed, :fri_open, :latitude, :longitude, :mon_closed, :mon_open, :phone, :sat_closed, :sat_open, :sun_closed, :sun_open, :thu_closed, :thu_open, :tue_closed, :tue_open, :wed_closed, :wed_open, 
                  :kmlfilename, :delivery_fri_closed, :delivery_fri_open, :delivery_mon_closed, :delivery_mon_open, :delivery_phone, :delivery_sat_closed, :delivery_sat_open, :delivery_sun_closed, :delivery_sun_open, :delivery_thu_closed, :delivery_thu_open, 
                  :delivery_tue_closed, :delivery_tue_open, :delivery_wed_closed, :delivery_wed_open, :latitude, :longitude, :printer_ip, :printer_port, :kmlfilename_b, :order_online, :kml, :kml_b, :google_maps_url, :receive_order_confirmation_emails, :email, 
                  :remove_kml, :remove_kml_b, :seo_metadescription, :seo_title, :mon_full_day_close, :tue_full_day_close, :wed_full_day_close, :thu_full_day_close, :fri_full_day_close, :sat_full_day_close, :sun_full_day_close, :enable_pos_orders, :enable_printer_orders,
                  :bambora_dev_merchant_id, :bambora_dev_api_key, :bambora_pro_merchant_id, :bambora_pro_api_key, :enable_online_payments, :bambora_env, :city, :postal_code, :province
  
  geocoded_by :latitude  => :latitude, :longitude => :longitude
  
  has_many :orders
  has_many :discount_code_filter
  
  
  # uploaders for KML files
  
  mount_uploader :kml, KmlUploader
  mount_uploader :kml_b, KmlUploader

  # for encryption
  attr_encrypted :bambora_dev_merchant_id, key: 'eb693ec8252cd630102fd0d0fb7c3485'
  attr_encrypted :bambora_dev_api_key, key: 'eb693ec8252cd630102fd0d0fb7c3485'
  attr_encrypted :bambora_pro_merchant_id, key: 'eb693ec8252cd630102fd0d0fb7c3485'
  attr_encrypted :bambora_pro_api_key, key: 'eb693ec8252cd630102fd0d0fb7c3485'

  def encryption_key
    # Rails.application.secrets.encryption_key
    'eb693ec8252cd630102fd0d0fb7c3485'
  end

  # def late_night?
  #   @today = Time.now.strftime("%a").downcase + "_closed"
  #   # FranchiseLocation.where('TIME() BETWEEN ? AND ?', '00:01:00', '08:00:00')
  #   closed_time = self.send(@today)

  #   puts closed_time.strftime("%H:%M:%S")

  #   if closed_time.strftime("%H:%M:%S") > "00:01:00" && closed_time.strftime("%H:%M:%S") < "07:00:00" 
  #     return true
  #   else
  #     return false
  #   end
  # end

  def self.late_night_locations
    # if Time.now.strftime("%H:%M:%S") < "23:59:59"
    #   @when = Time.now
    # else
    #   @when = Time.now - 1.day 
    # end 

    @when = Time.now
    
    @day = @when.strftime("%a").downcase + "_closed"
    
    locations = []

    FranchiseLocation.all.each do |location|
      if location.send(@day).strftime("%H:%M:%S") > "00:01:00" && location.send(@day).strftime("%H:%M:%S") < "07:00:00" 
        locations << location
      end
    end

    return locations
  end
  
  def printer_online

		begin
		  timeout(1) do
		    printer = Rescpos::Printer.open(self.printer_ip,self.printer_port.to_i)
		    printer.close
		  end
		  return true
		rescue
		  return false
		end
    
  end
  
  
    
  def location_in_area(lat,lon)
    
    # can now use 2 kml files if required...
    
    result = false
    
    unless self.kml_b.blank?
      region = BorderPatrol.parse_kml(File.read( Rails.root.join(self.kml_b.current_path) ))
      point = BorderPatrol::Point.new(lat,lon)
      if region.contains_point?(point)
        result = true
      end
    end
    
    unless self.kml.blank?
      region = BorderPatrol.parse_kml(File.read( Rails.root.join(self.kml.current_path) ))
      point = BorderPatrol::Point.new(lat,lon)
      if region.contains_point?(point)
        result = true
      end
    end
    
    return result
    
  end
  
  
  # ASSUMPTIONS:
  # ------------------------------------
  
  # DELIVERY TIME = 55 minutes
  # PICKUP TIME = 20 minutes
  
  # ------------------------------------
  
  
  # pickup is good as is!
  
  
  # IS THE LOCATION OPEN?
  #=====================================
  
  def open_for_business
    if Time.now.hour < CUTOFF_HOUR_FOR_LATE_NIGHT_LOCATIONS
      if Time.now < self.yesterday_closed_datetime
        return true
      else
        return false
      end
    else
      if Time.now > self.open_datetime && Time.now < self.closed_datetime
        return true
      else
        if Time.now < self.yesterday_closed_datetime
          return true
        else
          return false
        end
      end
    end
  end
  
  
  
  def open_for_deliveries

    # note, changed to be open only, no buffer time to order before opening
    if Time.now.hour < CUTOFF_HOUR_FOR_LATE_NIGHT_LOCATIONS
      current_time = Date.today - 1.day
      close_day = "#{current_time.strftime("%a").try(:downcase)}_full_day_close"
      if self.send(close_day)
        return false
      else
        if Time.now > self.open_for_delivery_datetime && Time.now < self.closed_for_delivery_datetime
          return true
        else
          if Time.now < self.yesterday_closed_datetime 
            return true
          else
            return false
          end
        end
      end
    else
      close_day = "#{Time.now.strftime("%a").try(:downcase)}_full_day_close"
      if self.send(close_day)
        return false
      else
        if Time.now + FRANCHISE_LOCATION_DELIVERY_OFFSET > self.open_for_delivery_datetime && Time.now < self.closed_for_delivery_datetime
          return true
        else
          if Time.now < self.yesterday_closed_datetime
            return true
          else
            return false
          end
        end
      end
    end
    
    
  end
  
  
  def open_for_pickup
    
    if Time.now.hour < CUTOFF_HOUR_FOR_LATE_NIGHT_LOCATIONS
      current_time = Date.today - 1.day
      close_day = "#{current_time.strftime("%a").try(:downcase)}_full_day_close"
      if self.send(close_day)
        return false
      else
        if Time.now + FRANCHISE_LOCATION_PICKUP_OFFSET > self.open_for_pickup_datetime && Time.now < self.closed_for_pickup_datetime
          return true
        else
          if Time.now < self.yesterday_closed_for_pickup_datetime
            return true
          else
            return false
          end
        end
      end
    else
      close_day = "#{Time.now.strftime("%a").try(:downcase)}_full_day_close"
      if self.send(close_day)
        return false
      else
        if Time.now + FRANCHISE_LOCATION_PICKUP_OFFSET > self.open_for_pickup_datetime && Time.now < self.closed_for_pickup_datetime
          return true
        else
          if Time.now < self.yesterday_closed_for_pickup_datetime
            return true
          else
            return false
          end
        end
      end
    end
  end
  
  
  
  # GET ASAP DELIVERY TIMES
  #=====================================
  
  def deliver_asap_eta

    if self.open_for_deliveries == true
      return Time.now + FRANCHISE_LOCATION_DELIVERY_OFFSET
    else
      close_day = "#{Time.now.strftime("%a").try(:downcase)}_full_day_close"
      if self.send(close_day)
        return tomorrow_open_for_delivery_datetime
      else
        if Time.now < open_for_delivery_datetime
          # deliver first thing today
          return open_for_delivery_datetime
        else
          # deliver first thing next day
          return tomorrow_open_for_delivery_datetime
        end
      end
    end
    
  end
  
  def pickup_asap_eta
    
    if self.open_for_pickup == true
      return Time.now + FRANCHISE_LOCATION_PICKUP_OFFSET
    else
      close_day = "#{Time.now.strftime("%a").try(:downcase)}_full_day_close"
      if self.send(close_day)
        return tomorrow_open_for_pickup_datetime
      else
        if Time.now < open_for_pickup_datetime
          # deliver first thing today
          return open_for_pickup_datetime
        else
          # deliver first thing next day
          return tomorrow_open_for_pickup_datetime
        end
      end
    end
    
  end
  
  
  
  
  
  # CAN AN ORDER BE FUILFILLED AT THESE TIMES
  #=================================
  
  def can_be_ready_at_this_datetime(time, for_pickup)
    
    puts "This is the requested delivery Time: #{time}"
    
    if for_pickup == true

      if time > Time.now + FRANCHISE_LOCATION_PICKUP_OFFSET
      
        if time >= self.open_for_pickup_on_datetime(time) && time < self.closed_for_pickup_on_datetime(time)
          return true
        else
          if time < self.yesterday_closed_for_pickup_on_datetime(time)
            return true
          else
            return false
          end
        end
      
      else
        
        return false
        
      end
      
    else
      if time >= Time.now + FRANCHISE_LOCATION_DELIVERY_OFFSET
      
        if time >= self.open_for_delivery_on_datetime(time) && time < self.closed_for_delivery_on_datetime(time)
          return true
        else
          if time < self.yesterday_closed_for_delivery_on_datetime(time)
            return true
          else
            return false
          end
        end
      
      else
        
        return false
        
      end
      
    end
    
  end
  
  
  
  
  
  
  # GET THE OPENING/CLOSING TIMES FOR VARIOUS STATES
  #=========================================================
  
  
  def open_datetime
    
    # GET THE DATETIME FOR PHYSICALLY OPENING THE STORE
    
    current_time = Date.today
    
    day_reference = Time.now.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  def tomorrow_open_datetime
    
    # GET THE DATETIME FOR PHYSICALLY OPENING THE STORE
    
    current_time = Date.today + 1.day
    
    day_reference = Time.now.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  
  def closed_datetime
    
    # GET THE DATETIME FOR PHYSICALLY CLOSING THE STORE
    
    current_time = Date.today
    
    today_reference = Time.now.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
  end
  
  
  
  def yesterday_closed_datetime
    
    # GET THE DATETIME FOR PHYSICALLY CLOSING THE STORE YESTERDAY
    
    current_time = Date.today - 1.day
    
    today_reference = current_time.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
  end
  
  
  
  
  

  
  def open_for_delivery_datetime
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR DELIVERY
    
    current_time = Date.today
    
    day_reference = Time.now.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("delivery_#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("delivery_#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  def open_for_delivery_on_datetime(time)
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR DELIVERY
    
    current_time = time.to_date
    
    day_reference = time.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("delivery_#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("delivery_#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  def tomorrow_open_for_delivery_datetime
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR DELIVERY
    
    current_time = Date.today + 1.day

    close_day = "#{current_time.strftime("%a").try(:downcase)}_full_day_close"

    if self.send(close_day)
      current_time = current_time + 1.day
    end
    
    day_reference = Time.now.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("delivery_#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("delivery_#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end

  def opening_time
    begin
      current_date = Date.today
      day_reference = Time.now.strftime('%A').downcase[0..2]
      opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
      opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
      opening_datetime = current_date + opening_time_hour.hours + opening_time_minutes.minutes
      return opening_datetime
    rescue => exception
      return Time.now.beginning_of_day + 11.hours
    end
  end
  
  
  def open_for_pickup_datetime
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR PICKUP
    
    current_time = Date.today
    
    day_reference = Time.now.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  def open_for_pickup_on_datetime(time)
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR PICKUP
    
    current_time = time.to_date
    
    day_reference = time.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  

  def tomorrow_open_for_pickup_datetime
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR PICKUP
    
    current_time = Date.today + 1.day

    close_day = "#{current_time.strftime("%a").try(:downcase)}_full_day_close"

    if self.send(close_day)
      current_time = current_time + 1.day
    end
    
    day_reference = current_time.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  def tomorrow_open_for_pickup_on_datetime(time)
    
    # GET THE DATETIME FOR ORDERS OPENING TIME FOR PICKUP
    
    current_time = time.to_date + 1.day
    
    day_reference = time.strftime('%A').downcase[0..2]
    
    opening_time_hour = self.send("#{day_reference}_open").strftime('%H').to_i
    opening_time_minutes = self.send("#{day_reference}_open").strftime('%M').to_i
    
    if opening_time_hour == 0
      opening_time_hour = 24
    end
    
    opening_datetime = current_time + opening_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + opening_time_minutes.minutes
    
    return opening_datetime
    
  end
  
  
  
  
  def closed_for_delivery_datetime
    
    # GET THE DEADLINE DATETIME FOR DELIVERY
    
    current_time = Date.today
    
    today_reference = Time.now.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("delivery_#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("delivery_#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
  end
  
  def closed_for_pickup_datetime
    
    # GET THE DEADLINE DATETIME FOR PICKUP
    
    current_time = Date.today
    
    today_reference = Time.now.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
  end
  
  
  
  def yesterday_closed_for_pickup_datetime
    
    # GET THE DEADLINE DATETIME FOR PICKUP YESTERDAY
    
    current_time = Date.today - 1.day
    
    today_reference = current_time.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
    
  end
  
  def yesterday_closed_for_delivery_datetime
    
    # GET THE DEADLINE DATETIME FOR DELIVERY YESTERDAY
    
    current_time = Date.today - 1.day
    
    today_reference = current_time.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("delivery_#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("delivery_#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
    
  end
  
  
  
  
  
  
  
  
  
  
  
  def closed_for_delivery_on_datetime(time)
    
    # GET THE DEADLINE DATETIME FOR DELIVERY
    
    current_time = time.to_date
    
    today_reference = time.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("delivery_#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("delivery_#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
  end
  
  def closed_for_pickup_on_datetime(time)
    
    # GET THE DEADLINE DATETIME FOR PICKUP
    
    current_time = time.to_date
    
    today_reference = time.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + closing_time_minutes.minutes
    end
    
    return closing_datetime
    
  end
  
  
  
  def yesterday_closed_for_pickup_on_datetime(time)
    
    # GET THE DEADLINE DATETIME FOR PICKUP YESTERDAY
    
    current_time = time.to_date - 1.day

    today_reference = current_time.strftime('%A').downcase[0..2]
    
    closing_time_hour = self.send("#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + FRANCHISE_LOCATION_PICKUP_OFFSET + closing_time_minutes.minutes
    end
    
    
    return closing_datetime
    
    
  end
  
  def yesterday_closed_for_delivery_on_datetime(time)
    
    # GET THE DEADLINE DATETIME FOR DELIVERY YESTERDAY
    
    current_time = time.to_date - 1.day
    
    today_reference = current_time.strftime('%A').downcase[0..2]
    
    puts "previous day: #{today_reference}"
    
    closing_time_hour = self.send("delivery_#{today_reference}_closed").strftime('%H').to_i
    closing_time_minutes = self.send("delivery_#{today_reference}_closed").strftime('%M').to_i
    
    if closing_time_hour == 0 && closing_time_minutes == 0
      opening_time_hour = 24
      opening_time_minutes = 0
    end
    
    if closing_time_hour < 12
      # it is in the AM
      closing_datetime = current_time + 1.day + closing_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + closing_time_minutes.minutes
    else
      # it is int he PM
      closing_datetime = current_time + closing_time_hour.hours + FRANCHISE_LOCATION_DELIVERY_OFFSET + closing_time_minutes.minutes
    end
    
    puts "the place closes for deliveries at: #{closing_datetime}"
    
    return closing_datetime
    
    
  end
  
  
  
  
  
  
  def open_today
    day_reference = Time.now.strftime('%A').downcase[0..2]
    self.send("#{day_reference}_open").to_s
  end
  
  def closed_today
    day_reference = Time.now.strftime('%A').downcase[0..2]
    self.send("#{day_reference}_closed").to_s
  end
  
  
  
  
  def open_for_orders(for_pickup)
    
    current_time = Time.now
    
    if for_pickup == false
      order_time = current_time + FRANCHISE_LOCATION_DELIVERY_OFFSET
    else
      order_time = current_time + FRANCHISE_LOCATION_PICKUP_OFFSET
    end
  
    puts "tc time: #{current_time}"
  
    today_reference = Time.now.strftime('%A').downcase[0..2]
    yesterday_reference = (Time.now - 1.day).strftime('%A').downcase[0..2]
    tomorrow_reference = (Time.now + 1.day).strftime('%A').downcase[0..2]
  
    today_open_time = self.send("#{today_reference}_open")
  
    puts self.send("#{today_reference}_closed").strftime('%H').to_i
  
    if self.send("#{today_reference}_closed").strftime('%H').to_i < 12
      today_closed_time = '23:59:59'
    else
      today_closed_time = self.send("#{today_reference}_closed") - FRANCHISE_LOCATION_DELIVERY_OFFSET
    end
  
    puts "today_open_time: #{today_open_time}"
    puts "today_closed_time: #{today_closed_time}"
    
    if for_pickup == true
      opening_time_adj = FRANCHISE_LOCATION_PICKUP_OFFSET
    else
      opening_time_adj = FRANCHISE_LOCATION_DELIVERY_OFFSET
    end

    if order_time > today_open_time + opening_time_adj && order_time < today_closed_time
      return true
    else
    
      if self.send("#{today_reference}_closed").strftime('%H').to_i < 12
      
        if current_time < self.send("#{yesterday_reference}_closed") - FRANCHISE_LOCATION_DELIVERY_OFFSET
          return true          
        else
          return false
        end
      
      else
        return false
      end
    
    end

    
  end
  
  def address_long_form
    return "#{self.address}, #{self.area_name}"
  end

  def pos_port
    ENV["POS_PORT_#{self.id}"] ? ENV["POS_PORT_#{self.id}"] : 8227
  end

  def add_api_key_and_store_id
    self.api_key ||= SecureRandom.uuid    
    self.store_id ||= SecureRandom.uuid
  end
  
end
