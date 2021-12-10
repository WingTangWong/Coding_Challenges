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
puts " "
landscape.display
puts " "
landscape.display_with_minima
landscape.remove_nines

puts " "
basin_sizes=[]
for (mr,mc)  in landscape.get_minimas do
  basin_sizes.append(landscape.fill_touching( mr,mc))
  puts " "
end
basin_sizes=basin_sizes.sort
basins=basin_sizes.length - 1
bs=basin_sizes[-1] * basin_sizes[-2] * basin_sizes[-3]
puts "Three largest basins product: #{bs} ( From: %s, %s, %s )" % [ basin_sizes[-1] , basin_sizes[-2] , basin_sizes[-3]]
