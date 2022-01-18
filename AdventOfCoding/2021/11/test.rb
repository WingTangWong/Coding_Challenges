#!/usr/bin/env ruby
#
require 'pp'
require './flashmap'

DEBUG=false

if ARGV[0] != nil then
  src=ARGV[0]
  raw_data=File.open(src).readlines.map(&:chomp)
else
  raw_data="11111
19991
19191
19991
11111".split()
end

if ARGV[1] != nil then
  if ARGV[1].to_s == "-d" then
    DEBUG=true
  end
end

octo_map=FlashMap.new
octo_map.ingest(raw_data)
for z in 0.upto(20) do
  octo_map.display
  octo_map.do_step
end
