#!/usr/bin/env ruby
# 
# Lava flows and smoke...
# Now.. need to find basins...
#
# Basins are defined as any connected low points below 9
# Basin size is defined as the number of adjacent points

require './Geographical'

DEBUG=false
PARAMS=ARGV

if PARAMS.length < 1 then
  puts "Missing file"
  exit
end

landscape = Geographical.new

raw_data=File.open(PARAMS[0]).readlines.map(&:chomp)

landscape.ingest(raw_data)

landscape.display
puts " " 
landscape.display_with_minima

#landscape.is_local_minima?(1,1)
