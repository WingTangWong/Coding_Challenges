#!/usr/bin/env ruby
# 
# Syntax errors.... detect and maybe fix matching brackets...
#
# If a chunk opens with (, it must close with ).
# If a chunk opens with [, it must close with ].
# If a chunk opens with {, it must close with }.
# If a chunk opens with <, it must close with >.

DEBUG=false
PARAMS=ARGV

if PARAMS.length < 1 then
  puts "Missing file"
  exit
end

raw_data=File.open(PARAMS[0]).readlines.map(&:chomp)
