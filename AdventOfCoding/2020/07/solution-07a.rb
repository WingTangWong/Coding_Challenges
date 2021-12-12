#!/usr/bin/env ruby

require 'pp'
DEBUG   = true
SRC     = ARGV[0]
fh      = File.open(SRC)
rawdata = fh.readlines.map { | datum | datum.chomp }

# Looks like we will be parsing a file with some rules.
# 
#
#  light red bags contain 1 bright white bag, 2 muted yellow bags.
#  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
#  bright white bags contain 1 shiny gold bag.
#  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
#  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
#  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
#  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
#  faded blue bags contain no other bags.
#  dotted black bags contain no other bags.
#
#
bag_colors=[]
bag_rules={}
gold_parent=[]



for line in rawdata do
  rule = line.split(/bags contain /)
  if !bag_colors.include?(rule[0]) then
    rule[0]=rule[0].split.join(" ")
    bag_colors.append(rule[0])
    bag_rules[rule[0].to_s]={}
  end
  if rule[1].include?("no other bag") then
    bag_rules[rule[0].to_s]=nil
  else
    for r in rule[1].split(/,/) do
      rr=r.split 
      rcolor="#{rr[1]} #{rr[2]}"
      rrnum=rr[0].to_i
      if rcolor == "shiny gold" then
        # We found a parent of a gold bag!
        gold_parent.append(rule[0].to_s)
      end
      if !bag_colors.include?(rcolor) then
        bag_colors.append(rcolor)
      end
      bag_rules[rule[0].to_s][rcolor] = rrnum
    end
  end
  bag_colors=bag_colors.sort.uniq
end


if DEBUG then
  puts "Bag Colors"
  pp bag_colors
  puts
  puts "Bag rules"
  pp bag_rules
  puts
  puts "Gold Bag Parents"
  pp gold_parent
end





# Okay, we've parsed the information... now to figure out... how many starting bags can eventually carry a gold bag.

# let's determine which colors can be an immediate parent of a "shiny gold" bag.

#  ["1 bright white bag", "2 muted yellow bags."]
#  ["3 bright white bags", "4 muted yellow bags."]
#  ["1 shiny gold bag."]
#  ["2 shiny gold bags", "9 faded blue bags."]
#  ["1 dark olive bag", "2 vibrant plum bags."]
#  ["3 faded blue bags", "4 dotted black bags."]
#  ["5 faded blue bags", "6 dotted black bags."]
