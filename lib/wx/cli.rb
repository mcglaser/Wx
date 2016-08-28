require "rubygems"
require "nokogiri"
require 'open-uri'
require 'cgi'

class Wx::CLI


  def call
    greeting
    detailed_weather
    get_weather
  end

  def greeting
    puts "Looking For Some Weather Info? Enter Your City Or Zip Code"
    @location = nil
    @location = gets
  end

  def detailed_weather
    puts @location
  end


  def get_weather
    url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{CGI.escape(@location)}"
    document  = Nokogiri::XML(open(url))
    
    forecast = document.css('fcttext')
    
    document.css("simpleforecast forecastday").each_with_index do |forecastday, i|
      highs = forecastday.css('high')
      lows  = forecastday.css('low')
      
      print "\n"
      print forecastday.css("date weekday").first.content
      print "\n"
      print " High: #{highs.css('fahrenheit').first.content} F / #{highs.css('celsius').first.content} C \n"
      print " Low:  #{lows.css('fahrenheit').first.content} F / #{lows.css('celsius').first.content} C   \n"
      print " #{forecast[i].content} \n" if forecast[i]
    end
    
    print "\n"
  end


end