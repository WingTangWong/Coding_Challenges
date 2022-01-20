#!/usr/bin/env ruby

DEBUG=false

PRACTICE1="data/sample.txt"
REAL_DATA="data/prod.txt"

#DATUM=open(REAL_DATA,"r").readlines.map(&:chomp)
DATUM=open(PRACTICE1,"r").readlines.map(&:chomp)

require 'pp'
require 'nmatrix'

# So... a starting state sequence at the top.
# All following lines create rules for what is to be inserted between the two

sequence_start=DATUM[0]

polymerization_rules={}
polymerization_result={}

for new_rule in DATUM do
    if new_rule.include? "->" then
      pair=new_rule.split(/ /)[0]
      result=new_rule.split(/ /)[2]
      polymerization_rules[pair]=result
      polymerization_result[pair]=pair[0] + result + pair[1]
    end
end

# pp(polymerization_result)

step=0

reaction={}

while true do
  if step == 0 then
    reaction["state"]=sequence_start.dup
    reaction["results"]=[]
    reaction["results"].append(reaction["state"])
    reaction["rules"]=polymerization_rules
    reaction["conversion"]=polymerization_result
  else
    polymer=reaction["state"].split(//)
    new_polymer=""
    for chain_pos in 0..polymer.length do
      if ( chain_pos + 1 ) == polymer.length then
        new_polymer += polymer[chain_pos]
        break
      end
      isomer="#{polymer[chain_pos]}#{polymer[chain_pos+1]}".upcase
      product=reaction["rules"][isomer]
      new_polymer += "%s%s" % [ polymer[chain_pos], product]
    end
    reaction["results"].append(new_polymer.dup)
    reaction["state"]=new_polymer.dup
    puts("Step #{step} : Length #{new_polymer.length} : #{new_polymer}")
  end
  if step == 10 then
    break
  end
  step += 1
end

tenth=reaction["state"].split(//)
histogram={}
for element in reaction["state"].split(//) do
  if histogram[element] == nil then
    histogram[element]=1
  else
    histogram[element] += 1
  end
end
numbers=histogram.values.sort
pop_max=numbers[-1]
pop_min=numbers[0]
pop_delta=pop_max-pop_min
puts("Delta: #{pop_delta}")
