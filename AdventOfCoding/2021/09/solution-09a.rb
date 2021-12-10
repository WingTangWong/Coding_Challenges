#!/usr/bin/env ruby
# 
# Lava flows and smoke...
# Gepgrahical height data...

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
