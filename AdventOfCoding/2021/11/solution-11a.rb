#!/usr/bin/env ruby

DEBUG=true
PARAMS=ARGV

if PARAMS.length < 1 then
  puts "Missing file"
  exit
end

raw_data=File.open(PARAMS[0]).readlines.map(&:chomp)

# 100 octopi
# 10 x 10 grid
# each gains energy over time and flashes when full
# navigate by predicting when the flashes will happen
#
# Energy levels between 0 and 9
# energy can be modelled as steps
#   - +1 to all energy
#   - if >9 then flash
#     - increases energy level of all surrounding by 1 (cross/diag)
#     - if this brings an octopus above 9, then it also flashes.
#     - any octopi can only flash one per step
#     - when an octopi flashes, it's energy is reduced to 0
#
# With the test data set, after 100 steps, there has been 1656 flashes

require './octopi'

octopi=Octopi.new(raw_data[0].length,raw_data.length)
octopi.ingest(raw_data)
octopi.display

for step in 0.upto(10) do
  octopi.do_step
  octopi.display
  puts
end
