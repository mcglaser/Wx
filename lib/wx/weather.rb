require "rubygems"
require "nokogiri"
require 'open-uri'
require 'cgi'

class Wx::Weather

# attr_accessor :name, :price, :availability, :url
  
  def self.test
   self.greeting
   if self.invalid_city?
        puts "INVALID!!!!!!!!"
      else
        puts "valid dude!!!!!!"
    end
   self.get_weather
  end


    def self.greeting
      puts "Looking For Some Weather Info? Enter Your City Or Zip Code:"
      @location = nil
      @location = gets
    end

  def self.today
    # probably don't need this method since we have #self.scrape_data
    self.scrape_data
  end




  def self.scrape_data
    data = []

    data << self.scrape_api

    data
  end


  def self.get_weather
      url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{@location}"
      document  = Nokogiri::XML(open(url))
      
      forecast = document.css('fcttext')

      if self.invalid_city?
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

  def self.invalid_city?
    #puts "Looking For Some Weather Info? Enter Your City Or Zip Code:"
    #@location = nil
    #@location = gets
    url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{@location}"
    document  = Nokogiri::XML(open(url))
    document.css("simpleforecast forecastday").empty?

  end



  







end