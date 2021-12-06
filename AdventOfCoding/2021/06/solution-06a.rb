#!/usr/bin/env ruby
# 
# Lantern fish population..
#
DEBUG=false
require 'matrix'

params=ARGV

if params.count < 2 then
  puts "Require a source file and number of iterations"
  exit
end

file = File.open(params[0])
stop_step=params[1].to_i
if stop_step < 1 then
  puts "Step needs to be 1 or more"
end

raw_data = file.readlines.map(&:chomp)

# Fish initial state read as one line with values separated by commas.
# So let's make it into an array of integers
lantern_fish=raw_data[0].split(/,/).map { |f| f.to_i }


step=0
prev_generation=lantern_fish
puts ">> Initial State [ #{step} ] [ Population #{prev_generation.length} ]"
while step < stop_step do
  step += 1
  new_generation=[]
  for fish in prev_generation do
    if fish == 0 then
      new_generation.append(6)
      new_generation.append(8)
    else
      new_generation.append(fish-1)
    end
  end
  puts ">> Generation [ #{step} ] [ Population #{new_generation.length} ]"
  prev_generation = new_generation
end




