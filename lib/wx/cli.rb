require "rubygems"
require "nokogiri"
require 'open-uri'
require 'cgi'

class Wx::CLI


  def call
    Wx::Weather.test
    learn_location
    goodbye
  end


  def learn_location
    @location = Wx::Weather.location
  end


  def goodbye
    puts "Thanks For Checking The Weather. Have A Wonderful Day!"
  end


end