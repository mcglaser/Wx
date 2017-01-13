require "rubygems"
require "nokogiri"
require 'open-uri'

class Wx::CLI


  def call
    greeting
    set_location
    Wx::Weather.display_days
    select_day
    more_weather
  end

  def greeting
    puts "For Weather Information, Enter Your City Or Zip Code:"
  end


  def set_location
    location = nil
    location = gets.strip
      if Wx::Weather.invalid_city?(location)
        puts "We Did Not Recognize The City You Entered. Please Enter Your City Or Zip Code Again:"
        set_location
      else
        Wx::Scraper.scrape_api(location) 
      end
    end

  def select_day

      input = nil
      input = gets.strip.downcase
      puts

      if !Wx::Weather.input_valid?(input)
        puts "Invalid Choice."
        Wx::Weather.display_days
        select_day
      else
        Wx::Weather.show_weather(input)
      end
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