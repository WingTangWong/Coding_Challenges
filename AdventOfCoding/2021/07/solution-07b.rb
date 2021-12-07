#!/usr/bin/env ruby
# 
# Trecherous whales.... find least fuel path for crab submarines
# Case2: Fuel usage is +1 per step. :( 
DEBUG=false

PARAMS=ARGV


if PARAMS.length < 1 then
  crab_data=[16,1,2,0,4,2,7,1,2,14].to_a.sort
else
  crab_data=File.open(PARAMS[0]).readlines.map(&:chomp).join(",").split(",").map { |x| x.to_i }.to_a.sort
  if DEBUG then
    puts "#{crab_data}"
  end
end

FUEL_RATE=1.upto(crab_data.max + 100).to_a

def fuel_usage( positions , position )
  total_fuel=0

  for pos in positions do
    total_fuel += FUEL_RATE.slice(0,(pos-position.to_i).abs).sum
  end

  if DEBUG then
    puts total_fuel
  end
  return total_fuel
end

fuel_usages={}
if DEBUG then
  puts "#{crab_data.min} .. #{crab_data.max}"
end
for pos in (crab_data.min)..(crab_data.max) do
  fuel_usages[pos]=fuel_usage(crab_data,pos)
end

if DEBUG then
  puts "#{fuel_usages}"
end

min_fuel=fuel_usages.values.min
min_pos=fuel_usages.key(min_fuel)

puts "Minimum fuel usage at position [ #{min_pos} ] with #{min_fuel} units of fuel used." 

#puts "#{fuel_usages}"
exit
