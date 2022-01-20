#!/usr/bin/env ruby

DEBUG=false

PRACTICE1="data/sample.txt"
REAL_DATA="data/prod.txt"

DATUM=open(REAL_DATA,"r").readlines.map(&:chomp)

require 'pp'
require 'nmatrix'

# Day 13, transparent origami

# * Thermal camera
# * Need code from page 1 of manual to activate
# * page 1 = transparent paper with dots.
# * Need to fold according to puzzle input
# * 0,0 = top left
# * x,y
# * Fold instructions:
#   * "y = 7" :: Fold UP at line 7 (0,1,2,3,4,5,6) |
#   * "x = 5" :: Fold LEFT at column 5 (0,1,2,3,4) |
#
#  3,0
#  8,4
#  1,10
#  2,14
#  8,10
#  9,0
#  
#  fold along y=7
#  fold along x=5

points=[]
folds=[]
max_x=0
max_y=0
for raw in DATUM do
  if raw.include? "," then
    x=raw.split(/,/)[0].to_i
    y=raw.split(/,/)[1].to_i
    points.append( [x,y] )
    if x > max_x then
      max_x = x.dup
    end
    if y > max_y then
      max_y = y.dup
    end
  end
  if raw.include? "fold" then
    axis=raw.split(/=/)[0][-1].to_s
    addr=raw.split(/=/)[1].to_i
    folds.append([axis,addr])
  end
end

def display(sheet,x,y)
  rows=0
  cols=0
  stardata=""
  for rr in sheet do
    stardata += rr.join[0..x]
    puts(rr.join[0..x])
    rows += 1
    if rows > y then
      puts stardata.count("#")
      return
    end
  end
  puts stardata.count("#")
end

blank_row=[]
for y in 0..max_x do
  blank_row.append(".")
end

sheet=[]
for x in 0..max_y do
  sheet.append(blank_row.dup)
end

# Load points
for point in points do
  sheet[point[1]][point[0]]="#"
end

x_window=max_x
y_window=max_y

flip_count=0
for flips in folds do

  # Handle Y folds
  if flips[0] == "y" then
    flip_count += 1
    y_window = flips[1].to_i
    # Draw the line at row y
    for x in 0..max_x do
      sheet[flips[1]][x] = "-"
    end
    # Now, let's copy over the points
    for y in 0..flips[1]-1 do
      for x in 0..max_x do
        if sheet[flips[1]+1+y][x] == "#" then
          sheet[flips[1]-1-y][x] = sheet[flips[1]+1+y][x]
          sheet[flips[1]+1+y][x] = "."
        end
      end
    end
  end

  # Handle X folds
  if flips[0] == "x" then
    flip_count += 1
    x_window = flips[1].to_i
    for y in 0..max_y do
      sheet[y][flips[1]] = "|"
    end
    # Now, let's copy over the points
    for y in 0..max_y do
      for x in 0..flips[1]-1 do
        if sheet[y][flips[1]+1+x] == "#" then
          sheet[y][flips[1]-1-x] = sheet[y][flips[1]+1+x] 
          sheet[y][flips[1]+1+x] = "."
        end
      end
    end
  end

  if flip_count > 0 then
    break
  end
end

display(sheet,x_window,y_window)
