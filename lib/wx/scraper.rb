require "rubygems"
require "nokogiri"
require 'open-uri'


class Wx::Scraper

  attr_accessor :days, :highs, :lows

	def self.scrape_api(location)
     url       = "http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{location}"
      document  = Nokogiri::XML(open(url))
      
      days = []
      highs = []
      lows = []

      document.css("simpleforecast forecastday").each_with_index do |forecastday|
        days << forecastday.css("date weekday").first.content
        highs << forecastday.css('high fahrenheit').first.content
        lows << forecastday.css('low fahrenheit').first.content
      end


      Wx::Weather.new(days, highs, lows)
      end



end

