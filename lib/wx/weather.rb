require "rubygems"
require "nokogiri"
require 'open-uri'
require 'cgi'

class Wx::Weather

# attr_accessor :day, :high, :low, :forecast
  
  def self.test
   self.greeting
   self.scrape_api
   self.select_day
  #self.get_weather
  end


    def self.greeting
      puts "Looking For Some Weather Info? Enter Your City Or Zip Code:"
      @location = nil
      @location = gets
      puts
    end

    def self.location
      @location
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
    url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{@location}"
    document  = Nokogiri::XML(open(url))
    document.css("simpleforecast forecastday").empty?
  end



  def self.scrape_api
    url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{@location}"
    document  = Nokogiri::XML(open(url))
    
    @days = []
    @highs = []
    @lows = []
    @forecasts = []

    document.css("simpleforecast forecastday").each_with_index do |forecastday|
      @days << forecastday.css("date weekday").first.content
      @highs << forecastday.css('high')
      @lows << forecastday.css('low')
      @forecasts << forecastday.css('fcttext')
    end

    document.css('fcttext').each do |forecast|
      @forecasts << forecast
    end
  end

  def self.select_day
    number = 1
    
    puts "Enter The Number For The Day You Want Weather Info For. Type ALL For A Weekly Forecast."
    
    @days.each do |day|
      puts "#{number}) " + day
      number = number + 1
    end

    @input = nil
    @input = gets.strip.downcase
    puts

    if !self.input_valid?
      puts "Invalid Choice."
      self.select_day
    end
  end

  def self.input_valid?
    if (1..6).cover?(@input.to_i)
      true
      elsif
      @input == "all"
      true
    else 
      false
    end
  end







end