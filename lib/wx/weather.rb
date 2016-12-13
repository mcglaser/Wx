require "rubygems"
require "nokogiri"
require 'open-uri'


class Wx::Weather
  


    def self.process
     self.scrape_api
     self.select_day
     self.show_weather
    end


    def self.greeting
      puts "For Weather Information, Enter Your City Or Zip Code:"
    end

    def self.set_location
      @location = nil
      @location = gets.strip
      puts
      if self.invalid_city?
        puts "We Did Not Recognize The City You Entered. Please Enter Your City Or Zip Code Again:"
        self.set_location
      end
    end

    def self.location
      @location
    end


    def self.weekly_weather
      url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{@location}"
      document  = Nokogiri::XML(open(url))
      
      forecast = document.css('fcttext')

      puts "Here's Your Detailed Forecast For #{@location.capitalize}:"
      
      document.css("simpleforecast forecastday").each_with_index do |forecastday, i|
        highs = forecastday.css('high')
        lows  = forecastday.css('low')
        
        puts
        puts forecastday.css("date weekday").first.content
        puts
        puts " High: #{highs.css('fahrenheit').first.content} F / #{highs.css('celsius').first.content} C \n"
        puts " Low:  #{lows.css('fahrenheit').first.content} F / #{lows.css('celsius').first.content} C   \n"
        puts " #{forecast[i].content} \n" if forecast[i]
      end
      
      puts "\n"
    end

    def self.invalid_city?(location)
      url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{location}"
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
      
      puts "Enter The Number For The Day You Want Weather Info For. Type ALL For A Detailed Weekly Forecast."
      
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

    def self.show_weather
      if (1..6).cover?(@input.to_i)
        self.single_day_weather
      else
        self.weekly_weather
      end
    end


   def self.single_day_weather
    puts "In #{@location.capitalize} on #{@days[@input.to_i-1]} there will be a high of #{@highs[@input.to_i-1].css('fahrenheit').first.content} Fahrenheit / #{@highs[@input.to_i-1].css('celsius').first.content} Celsius"
    puts "The low will be #{@lows[@input.to_i-1].css('fahrenheit').first.content} Fahrenheit / #{@lows[@input.to_i-1].css('celsius').first.content} Celsius"
    puts
  end



end