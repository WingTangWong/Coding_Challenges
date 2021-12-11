#!/usr/bin/env ruby

require 'pp'
SRC     = ARGV[0]
fh      = File.open(SRC)

# Second half.. need to get where everyone voted the same.
#
#   abc
# 
#   a
#   b
#   c
# 
#   ab
#   ac
# 
#   a
#   a
#   a
#   a
# 
#   b
#
#
rawdata = fh.readlines.map(&:chomp).map { |x| x==""  ? "#" : x }.join(':').split("#")
# ["abc:", ":a:b:c:", ":ab:ac:", ":a:a:a:a:", ":b"]

groups={}

def alpha_to_bit( start_state=[0]*26, c )
  result = start_state
  for symbol in 'a'.upto('z') do
    if c.include?(symbol) then
      result[(symbol.ord - 'a'.ord).to_i] += 1
    end
  end
  return result
end

for g in rawdata do
  group = []
  if g[-1] == ":" then
    g=g.delete_suffix(":")
  end
  if g[0] == ":" then
    g=g.split(//).drop(1).join
  end
  gstate=[0]*26
  gall=0 
  for i in g.split(/:/).to_a do
    gall += 1
    gstate=alpha_to_bit( gstate, i )
  end
  gcount=0
  gstate.map { |x| x==gall ? gcount += 1 : true }
  groups[g]=gcount
end

scores=0

print "Scores: "
groups.map { |k,v| print "#{v}, "; scores += v }
puts " "
puts "Group Tally: #{scores}"
