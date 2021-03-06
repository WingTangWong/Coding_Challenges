#!/usr/bin/env ruby

params=ARGV

if params.count < 1 then
  puts "Require a source file."
  exit
end

file = File.open(params[0])

depths=file.readlines.map(&:chomp)
readings=0
depth_increases=0
previous_reading=0
for depth in depths do
  puts "#{depth} , #{previous_reading}"
  if readings > 0 then 
    if ( depth.to_i > previous_reading ) then
      depth_increases = depth_increases + 1
    end
  end
  previous_reading = depth.to_i
  readings = readings + 1
end

puts(depth_increases)
