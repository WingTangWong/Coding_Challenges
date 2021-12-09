#!/usr/bin/env ruby
# 
# Trecherous whales.... find least fuel path for crab submarines
# Case2: Fuel usage is +1 per step. :( 

require './SevenSegment'

DEBUG=true
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
  figure=""
  display=SevenSegment.new
  parts = dline.split(/ [|] /)
  display.ingest(parts[0])

  for term in parts[1].split(/ /).map(&:chomp) do
    figure += display.to_digit(term).to_s
  end
  puts figure
  tally += figure.to_i
end


puts "Target sum: #{tally}."
