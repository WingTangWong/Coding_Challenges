#!/usr/bin/env ruby
# 
# Trecherous whales.... find least fuel path for crab submarines
#
DEBUG=false

PARAMS=ARGV

if PARAMS.length < 1 then
  crab_data=[16,1,2,0,4,2,7,1,2,14].to_a.sort
else
  crab_data=File.open(ARGV[0]).readline.split(/,/).to_a.sort
end

def fuel_usage( positions , position )
  fuel_used=positions.map { |p| ( position.to_i.abs - p.to_i.abs).abs }
  if DEBUG then
    puts "#{fuel_used.sum}"
  end
  return fuel_used.sum
end

#crabs=DATA.readline.split(/,/).map{ |x| x.to_i }

fuel_usages={}
for pos in crab_data do
  fuel_usages[pos]=fuel_usage(crab_data,pos)
end

if DEBUG then
  puts "#{fuel_usages}"
end

min_fuel=fuel_usages.values.min
min_pos=fuel_usages.key(min_fuel)

puts "Minimum fuel usage at position [ #{min_pos} ] with #{min_fuel} units of fuel used." 
exit
