class Weather < OpenStruct
  def wind_speed
    speed = wind_kph
    if speed
      (speed / 3.6).round(2)
    else
      0
    end
  end

  def icon
    condition['icon'] if condition
  end
end
