require 'net/http'
require 'uri'
require 'json'

class SendToPosWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 4, :queue => "critical"
  
  def perform(id)
    order = Order.find(id)
    send_to_pos(order)
  end

  def send_to_pos(order)
    header = {
      'Content-Type' => 'application/json'
    }
    
    if Rails.env.development?
      uri = URI.parse("http://localhost:8084/pizza_order_request")
      use_ssl = false
    elsif ENV["POS_WEBHOOK_URL_#{order.franchise_location_id}"]
      uri = URI.parse(ENV["POS_WEBHOOK_URL_#{order.franchise_location_id}"])
      use_ssl = false
    else
      # uri = URI.parse("http://sql.ecopos.ca:8080/pizza_order_request")
      uri = URI.parse("http://#{order.franchise_location.printer_ip.to_s}:#{order.franchise_location.pos_port.to_i}/pizza_order_request")
      use_ssl = false
    end

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, header)
    http.use_ssl = use_ssl
    request.body = order.order_attributes_for_pos.to_json

    begin
      response = http.request(request)
      order.sent_to_pos_at = Time.now
      order.save
    rescue Exception => e
      raise "Error occured #{e} \n #{order.order_attributes_for_pos.to_json}"
    end
  end
  
end