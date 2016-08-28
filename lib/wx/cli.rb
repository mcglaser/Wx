class Wx::CLI


  def call
    greeting
  end

  def greeting
    puts "What's The Weather Like Today? Enter Your City Or Zip Code"
    location = nil
    location = gets
    puts location
  end


end