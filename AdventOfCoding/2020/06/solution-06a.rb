#!/usr/bin/env ruby

SRC     = ARGV[0]
fh      = File.open(SRC)

rawdata = fh.readlines.map(&:chomp).map { |x| x==""  ? "#" : x }.join.split("#")
vote_tally = rawdata.map { |x| x.split(//).tally.keys.to_a.length }.sum

puts "#{vote_tally}"
