require 'open-uri'
require 'json'

module TwilioHelper
  
  def current_time(city, state)
    coordinates = coordinates(city, state)
    offset = offset(coordinates)
    time_s = (Time.now.utc + offset).strftime("%l:%M%p").strip
    "The time is #{time_s} in #{city}, #{state}."
  end
  
  def coordinates(city, state)
    city  = city.gsub(" ", "%20")
    state = state.gsub(" ", "%20")
  
    uri   = URI.parse("http://maps.googleapis.com/maps/api/geocode/" + 
                      "json?address=#{city},%20#{state}&sensor=false")
    geo_h = JSON.parse(uri.read)
  
    { lat: geo_h["results"][0]["geometry"]["location"]["lat"],
      lng: geo_h["results"][0]["geometry"]["location"]["lng"] }
  end
  
  def offset(coordinates)
    uri = URI.parse("https://maps.googleapis.com/maps/api/timezone/" + 
                    "json?location=#{coordinates[:lat]},#{coordinates[:lng]}" +
                    "&timestamp=1331161200&sensor=false")
    offset_h = JSON.parse(uri.read)
  
    offset_h["rawOffset"]
  end
end