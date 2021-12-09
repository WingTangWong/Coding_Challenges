#!/usr/bin/env ruby
# 
# Trecherous whales.... find least fuel path for crab submarines
# Case2: Fuel usage is +1 per step. :( 

require './SevenSegment'

DEBUG=false
PARAMS=ARGV
tally=0


if PARAMS.length < 1 then
  puts "Need to provide data file"
  exit
else
  raw_data=File.open(PARAMS[0]).readlines.map(&:chomp)
  if DEBUG then
    puts "#{raw_data}"
  end
end

all_digits=""
for dline in raw_data do
  display=SevenSegment.new
  parts = dline.split(/ [|] /)
  display.ingest(parts[0])

  for term in parts[1].split(/ /).map(&:chomp) do
    all_digits += display.to_digit(term).to_s
  end
  puts "#{all_digits}"
end

tallies=all_digits.split(//).tally
puts tallies
targets=[1,4,7,8]
for t in targets.to_s.split(//)  do
  tally += tallies[t].to_i
end


puts "Targets: #{targets} were found #{tally} times in the messags."
