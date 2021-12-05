#!/usr/bin/env ruby
# 
# Hydrothermal vents..

DEBUG=true
require 'matrix'

params=ARGV

if params.count < 1 then
  puts "Require a source file."
  exit
end

file = File.open(params[0])

raw_data = file.readlines.map(&:chomp)

