require "rubygems"
require "nokogiri"
require 'open-uri'
require 'cgi'

class Wx::CLI


  def call
    Wx::Weather.process
    more_weather
  end


  def more_weather
    puts "Would You Like To See Additional Weather Information? Type YES or NO:"
    answer = nil
    answer = gets.strip.downcase
    if answer == "yes"
      puts
      call 
    elsif answer == "no"
      goodbye
      else
        more_weather
    end
  end

  def goodbye
    puts
    puts "Thanks For Checking The Weather. Have A Wonderful Day!"
  end


end