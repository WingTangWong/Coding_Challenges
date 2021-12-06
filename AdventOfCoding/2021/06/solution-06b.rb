#!/usr/bin/env ruby
# 
# Lantern fish population..
#
DEBUG=false
require 'matrix'

params=ARGV

if params.count < 2 then
  puts "Require a source file and number of days"
  exit
end

fish=File.open(params[0]).readlines.map(&:chomp).join.split(",").map(&:to_i)

max_days=params[1].to_i
if max_days < 1 then
  puts "Days needs to be 1 or more"
end

# Notes...
# Fish can be ages 0 through 6 normally.
# Newborn fish can be 8 because of the 2 day delay
# No fish ever dies.

# Can we calculate how the iteration impacts the fish population without
# repeatedly iterating over the array and growing it?

population={}

# Let's setup the population as an array of ages with a count of fish in that age range.
population[0]=fish.count(0).to_i
population[1]=fish.count(1).to_i
population[2]=fish.count(2).to_i
population[3]=fish.count(3).to_i
population[4]=fish.count(4).to_i
population[5]=fish.count(5).to_i
population[6]=fish.count(6).to_i
population[7]=fish.count(7).to_i
population[8]=fish.count(8).to_i

days=0

def census( pop )
  popcount = 0
  for age_group in pop.keys do
    if age_group > 8 then
      break
    end
    popcount = popcount + pop[age_group]
  end
  return popcount
end

while days <= max_days do
  puts "Day [ #{days} ] :: Population [ #{population} ] [ #{census(population)}]"
  population[1000] = population[0].to_i
  population[0] = population[1].to_i
  population[1] = population[2].to_i
  population[2] = population[3].to_i
  population[3] = population[4].to_i
  population[4] = population[5].to_i
  population[5] = population[6].to_i
  population[6] = population[1000].to_i + population[7].to_i
  population[7] = population[8].to_i
  population[8] = population[1000].to_i
  population.delete(1000)
  days += 1
end
