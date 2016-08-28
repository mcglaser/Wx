class Wx::CLI


  def call
    greeting
    detailed_weather
  end

  def greeting
    puts "What's The Weather Like Today? Enter Your City Or Zip Code"
    @location = nil
    @location = gets
  end

  def detailed_weather
    puts @location
        puts @location
            puts @location
                puts @location
                    puts @location
                        puts @location
  end


end