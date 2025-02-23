#! /usr/bin/env ruby
# <bitbar.title>Homebrew - Outdated</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Angelmaneuver</bitbar.author>
# <bitbar.author.github>Angelmaneuver</bitbar.author.github>
# <bitbar.desc>Displays whether there are any updates in packages managed by Homebrew.</bitbar.desc>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>
# <swiftbar.schedule>*/30,* * * *</swiftbar.schedule>

COMMAND = { update: "brew update", outdated: "brew outdated -v" }
TITLE = "更新パッケージ"

stdouts = {}

stdouts[:update] = `#{COMMAND[:update]}`

stdouts[:outdated] = `#{COMMAND[:outdated]}`

if not 0 == stdouts[:outdated].length
  updates = stdouts[:outdated].split(/\R/)

  puts ":gear.badge:"
  puts "---"
  puts "#{TITLE}"

  updates.each { |package| puts "#{package}" }
else
  puts ":gear.badge.checkmark:"
end
