module StaticMapHelper
 
  def static_map_for(location, options = {})
    
    params = {
      :center => [location.lat, location.lon].join(","),
      :zoom => 15,
      :size => "120x120",
      :markers => [location.lat, location.lon].join(","),
      :sensor => true
    }.merge(options)
 
    query_string =  params.map{|k,v| "#{k}=#{v}"}.join("&")
    image_tag "http://maps.googleapis.com/maps/api/staticmap?#{query_string}", :alt => location.name
    
  end
 
 
end