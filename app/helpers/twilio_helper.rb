require 'open-uri'
require 'json'

module TwilioHelper
  
  def current_time(sms_message)
    if sms_message.match(/^what time is it in/i)
      city_state_s = sms_message.gsub(/(^what time is it in|[\s\W]*$)/i, "")
      city, state = city_state_s.split(",").map { |word| word.strip }
      
      city_data = city_data(city, state)
      offset = offset(city_data[:coordinates])
      time_s = (Time.now.utc + offset).strftime("%l:%M%p").strip
      "The time is #{time_s} in #{city_data[:address]}."
    else
      'Ask your question like this: "What time is it in Tucson, AZ?"'
    end
  end
  
  def city_data(city, state)
    city_data = {}
  
    city  = city.gsub(" ", "%20")
    state = state.gsub(" ", "%20")
  
    uri   = URI.parse("http://maps.googleapis.com/maps/api/geocode/" + 
                      "json?address=#{city},%20#{state}&sensor=false")
    data = JSON.parse(uri.read)
  
    city_data[:coordinates] = { 
      lat: data["results"][0]["geometry"]["location"]["lat"],
      lng: data["results"][0]["geometry"]["location"]["lng"] 
    }
    city_data[:address] = data["results"][0]["formatted_address"]
  
    city_data
  end
  
  def offset(coordinates)
    uri = URI.parse("https://maps.googleapis.com/maps/api/timezone/" + 
                    "json?location=#{coordinates[:lat]},#{coordinates[:lng]}" +
                    "&timestamp=1331161200&sensor=false")
    offset_h = JSON.parse(uri.read)
  
    offset_h["rawOffset"]
  end
end