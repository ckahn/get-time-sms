require 'open-uri'
require 'json'

module TwilioHelper
  
  def current_time(sms_message)
    if sms_message.match(/(^.*\btime\b.*\b(at|for|in)\b *)/i)
      location = sms_message.gsub(/(^.*\btime\b.*\b(at|for|in)\b *)|(\W*$)/i, "")
      city_data = city_data(location)
      
      if city_data[:status] == "OK"
        offset = offset(city_data[:coordinates])
        time_s = (Time.now.utc + offset).strftime("%l:%M%p").strip
        "The time is #{time_s} in #{city_data[:address]}."
      else
        city_data[:status]
      end
    else
      'Ask me for the local time (e.g., "What time is it in San Francisco?").'
    end
  end
  
  def city_data(location)
    city_data = {}
    location.gsub!(" ", "%20")
  
    uri   = URI.parse("http://maps.googleapis.com/maps/api/geocode/" + 
                      "json?address=#{location}&sensor=false")
    data = JSON.parse(uri.read)
  
    city_data[:coordinates] = { 
      lat: data["results"][0]["geometry"]["location"]["lat"],
      lng: data["results"][0]["geometry"]["location"]["lng"] 
    }
    city_data[:address] = data["results"][0]["formatted_address"]
    city_data[:status]  = data["status"]
    city_data
  end
  
  def offset(coordinates)
    uri = URI.parse("https://maps.googleapis.com/maps/api/timezone/" + 
                    "json?location=#{coordinates[:lat]},#{coordinates[:lng]}" +
                    "&timestamp=#{Time.now.to_i}&sensor=false")
    offset_h = JSON.parse(uri.read)
  
    offset_h["rawOffset"] + offset_h["dstOffset"]
  end
end