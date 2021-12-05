#!/usr/bin/env ruby
# 
# Hydrothermal vents..

DEBUG=false
require 'matrix'

params=ARGV

if params.count < 1 then
  puts "Require a source file."
  exit
end

file = File.open(params[0])
raw_data = file.readlines.map(&:chomp)

cooked_data = []
max_dimension = 0


class SparseMatrix
  def initialize
    @hash = {}
  end

  def [](row, col)
    if @hash[[row, col]] == nil then
      0
    else
      @hash[[row, col]]
    end
  end

  def []=(row, col, val)
    @hash[[row, col]] = val
  end

  def show
    tally=0
    for key,visits in @hash do
      if visits >= 2 then
        tally += 1
      end
    end
    return tally
  end
end

vent_map = SparseMatrix.new

def is_horizontal?( src, dst )
  valid = true
  if src[1] != dst[1] then
    valid = false
  end
  if DEBUG then
    puts ">> Horizontal: #{valid}"
  end
  return valid
end

def is_vertical?( src, dst )
  valid = true
  if src[0] != dst[0] then
    valid = false
  end
  if DEBUG then
    puts ">> Vertical: #{valid}"
  end
  return valid
end

def is_diagonal?( src, dst )
  valid = true
  if (src[0] == dst[0]) || (src[1] == dst[1]) then
    valid = false
  end
  if DEBUG then
    puts ">> Diagonal: #{valid}"
  end
  return valid
end

def plot_line( map, src, dst )
  if DEBUG then
    puts ">> plot_line :: #{src} -> #{dst}"
  end
  if !is_diagonal?( src,dst) then
    if is_horizontal?(src,dst) then
      y = src[1]
      if src[0] > dst[0] then
        a = dst[0]
        b = src[0]
      else
        a = src[0]
        b = dst[0]
      end
      if DEBUG then
        puts ">> X #{a} -> #{b}"
      end
      for x in a..b do
        if DEBUG then
          puts ">> H : ( #{x} , #{y} )"
        end
        map[x,y] = map[x,y] + 1
      end
    end
    if is_vertical?(src,dst) then
      x = src[0]
      if src[1] > dst[1] then
        a = dst[1]
        b = src[1]
      else
        a = src[1]
        b = dst[1]
      end
      if DEBUG then
        puts ">> Y #{a} -> #{b}"
      end
      for y in a..b do
        if DEBUG then
          puts ">> V : ( #{x} , #{y} )"
        end
        map[x,y] = map[x,y] + 1
      end
    end
  end
end


# Let's take the strings and parse them into coordinate pairs and also get the max dimension.
for entry in raw_data do
  fields=entry.split
  src=fields[0].split(/,/).map { |x| x.to_i }
  dst=fields[2].split(/,/).map { |x| x.to_i }
  cooked_data.append( [src,dst] )
  plot_line(vent_map, src,dst)
  if DEBUG then
    puts " "
  end
  if (src + dst).max > max_dimension then
    max_dimension = (src + dst).max
  end
end

puts ">> Max dimension: #{max_dimension}"
puts " "
# Okay, got the coordinate pairs and max dimension. Let's create the matrix.

if DEBUG then
  for y in 0..max_dimension+1 do
    for x in 0..max_dimension+1 do
      if x == 0 then
        if y == 0 then
          print "%02s " % [" "]
        else
          print "%02d " % [ y-1 ]
        end
      else
        if y == 0 then
          print "%02d " % [ x-1 ]
        else
          print "%02s " % [ (vent_map[x-1,y-1] == 0 ? "." : vent_map[x-1,y-1] ) ]
        end
      end
    end
    puts " "
  end
end

puts ">> Class Tally [ #{vent_map.show} ]"
