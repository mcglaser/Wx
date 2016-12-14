require "rubygems"
require "nokogiri"
require 'open-uri'


class Wx::Weather
  


    def self.process
     self.show_weather
    end


    def self.greeting
      puts "For Weather Information, Enter Your City Or Zip Code:"
    end


    def self.invalid_city?(location)
      url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{location}"
      document  = Nokogiri::XML(open(url))
      document.css("simpleforecast forecastday").empty?
    end



    def self.scrape_api(location)
      url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{location}"
      document  = Nokogiri::XML(open(url))
      
      @days = []
      @highs = []
      @lows = []

      document.css("simpleforecast forecastday").each_with_index do |forecastday|
        @days << forecastday.css("date weekday").first.content
        @highs << forecastday.css('high fahrenheit').first.content
        @lows << forecastday.css('low fahrenheit').first.content
      end

    end

    def self.display_days
       number = 1
      
       puts "Enter The Number For The Day You Want Weather Info For. Type ALL For The Weekly Forecast."
        
       @days.each do |day|
         puts "#{number}) " + day
         number = number + 1
       end
    end


    def self.input_valid?(input)
      if (1..6).cover?(input.to_i)
        true
        elsif
        input == "all"
        true
      else 
        false
      end
    end

    def self.show_weather(input)
      @input = input
      if (1..6).cover?(input.to_i)
        self.single_day_weather
      else
        self.week_weather
      end
    end


   def self.single_day_weather
    puts "On #{@days[@input.to_i-1]} there will be a high of #{@highs[@input.to_i-1]} Fahrenheit / #{@highs[@input.to_i-1]} Celsius"
    puts "The low will be #{@lows[@input.to_i-1]} Fahrenheit / #{@lows[@input.to_i-1]} Celsius"
    puts
   end

   def self.week_weather
    puts "Here's The Weekly Forecast:"
    puts
    @days.zip(@highs, @lows).each do |day, high, low|
      puts "#{day}:"
      puts "High: #{high} / Low: #{low}"
      puts
    end
        
      puts "\n"
    end

end