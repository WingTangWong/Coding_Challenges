#!/usr/bin/env ruby

DEBUG=false

PRACTICE1="data/sample.txt"
REAL_DATA="data/prod.txt"

DATUM=open(PRACTICE1,"r").readlines.map(&:chomp)
#DATUM=open(PRACTICE1,"r").readlines.map(&:chomp)

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


def polymerize
  # This definitely points past end of string, 
  polymerHead=$polymer.length
  polymerTail=$polymer.length+1
  chemH=$polymer[polymerHead]
  chemT=$polymer[polymerTail]
  # Seek backwards through string and perform insertions
  while chemT == nil do
    polymerHead -= 1
    polymerTail -= 1
    chemH=$polymer[polymerHead]
    chemT=$polymer[polymerTail]
  end
  while polymerTail > 0 do
    chemH=$polymer[polymerHead]
    chemT=$polymer[polymerTail]
    chemC=$REACTION[chemH + chemT]
    $polymer.insert(polymerTail,chemC)
    polymerHead -= 1
    polymerTail -= 1
  end
end
step=0
$REACTION=polymerization_rules.dup
$polymer=sequence_start.split(//).join
while step < 41 do
  puts("%5d : %15d" % [ step , $polymer.length ] )
  polymerize
  step += 1
end
