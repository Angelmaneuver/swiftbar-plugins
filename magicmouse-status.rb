#! /usr/bin/env ruby
# <bitbar.title>Magic Mouse - battery</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Angelmaneuver</bitbar.author>
# <bitbar.author.github>Angelmaneuver</bitbar.author.github>
# <bitbar.desc>Displays the battery status of the Magic Mouse.</bitbar.desc>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.schedule>*/5,* * * *</swiftbar.schedule>

DEVICE_NAME = "Magic Mouse"
THRESHOLDS = {
  color: {
    blue: 70,
    yellow: 40
  },
  icon: {
    full: 90,
    three_quarter: 65,
    half: 45,
    quarter: 15
  }
}
MESSAGE_TEMPLATE = "バッテリー %d%% :battery.%d:"
REGEXP_PRODUCT = Regexp.new(/"Product" += +"(.*?)"/)
REGEXP_BATTERY = Regexp.new(/"BatteryPercent" += +(\d*)/)

information = {}
pre_name = ""
color = "gray"
battery = ""

`ioreg -r -d 1 -k BatteryPercent | egrep '("BatteryPercent"|"Product")'`.split(
  /\R/
)
  .each_with_index do |line, index|
    if REGEXP_PRODUCT.match(line)
      pre_name = REGEXP_PRODUCT.match(line)[1]
    elsif REGEXP_BATTERY.match(line) && !pre_name.empty?
      information[pre_name] = REGEXP_BATTERY.match(line)[1]
    end
  end

if information.include?(DEVICE_NAME)
  color_thresholds = THRESHOLDS[:color]
  icon_thresholds = THRESHOLDS[:icon]
  battery = information[DEVICE_NAME].to_i

  if color_thresholds[:blue] <= battery
    color = "blue"
  elsif color_thresholds[:yellow] <= battery
    color = "yellow"
  else
    color = "red"
  end

  if icon_thresholds[:full] < battery
    icon = 100
  elsif icon_thresholds[:three_quarter] < battery
    icon = 75
  elsif icon_thresholds[:half] < battery
    icon = 50
  elsif icon_thresholds[:quarter] < battery
    icon = 25
  else
    icon = 0
  end

  battery = MESSAGE_TEMPLATE % [battery, icon]
end

puts ":magicmouse.fill: | sfcolor = #{color}"
puts "---"
puts battery if 0 < battery.length
