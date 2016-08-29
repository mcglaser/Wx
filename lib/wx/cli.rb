require "rubygems"
require "nokogiri"
require 'open-uri'
require 'cgi'

class Wx::CLI


  def call
    #greeting
    Wx::Weather.test
    #detailed_weather
    #get_weather
    goodbye
  end

  def greeting
    puts "Looking For Some Weather Info? Enter Your City Or Zip Code:"
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

    if document.css("simpleforecast forecastday").empty?
      puts "We Did Not Recognize The City You Entered. Please Enter Your City Or Zip Code Again:"
      @location = nil
      @location = gets
      get_weather 
    else
    
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

  def goodbye
    puts "Thanks For Checking The Weather. Have A Wonderful Day!"
  end


end