#!/usr/bin/env ruby
# 

require 'nmatrix'

DEBUG=false

PRACTICE="data/sample.txt"
REAL_DATA="data/prod.txt"

DATUM=open(PRACTICE,"r").readlines.map(&:chomp)

cols=DATUM[0].length
rows=DATUM.count

rr = rows-1
cc = cols-1

dataMatrix=NMatrix.new([rows,cols])
nextMatrix=NMatrix.new([rows,cols],0)
flashedMatrix=NMatrix.new([rows,cols], 1)

validRows=0..rr
validRows=validRows.to_a
validCols=0..cc
validCols=validCols.to_a

for row in 0..(rows-1)
  DATUM[row] = DATUM[row].split(//)
  for col in 0..(cols-1)
    dataMatrix[row,col] = DATUM[row][col].to_i
  end
end

# Okay, the rules of the state machines...
# 1. Energy level at each position = 0 through 9
# 2. At the start of each step, all positions increase energy by 1
# 3. After the increase, anything with a value > 9, flashes.
#    * Flashes increase the energy of all adjacent positions by one.
#    * Each octopus can only flash once per step.
# 4. Any octopus that has flashed, the energy gets set to 0

def displayMatrix( m )
  for r in 0..(m.rows-1) do
    for c in 0..(m.cols-1) do
      print(" %3d " % m[r,c])
    end
    puts("")
  end
end

# STEP START
#
puts("[START] Step start")
displayMatrix(dataMatrix)
puts("")
# 1. Increase all by 1
puts(">> +1")
dataMatrix[0..rr,0..cc] += 1
displayMatrix(dataMatrix)
puts("")


puts(">> If >9, flash")
# Let's determine which ones flashed.
flash_count=0
todo=[]
for r in 0..(rows-1) do
  for c in 0..(cols-1) do
    if dataMatrix[r,c] > 9 then
      flashedMatrix[r,c]=0
      flash_count += 1
      todo.append([r,c])
    end
  end
end

# Process the flashed items and their neighbors
for t in todo do
  tr=t[0]
  tc=t[1]
  for n in [ 
      [-1,-1], [-1, 0], [ -1, 1],
      [ 0,-1],          [  0, 1],
      [ 1,-1], [ 1, 0], [  1, 1],
    ] do
    nr=tr + n[0]
    nc=tc + n[1]
    if ( nr <= rr ) & ( nr >= 0 ) then
      if ( nc <= cc ) & ( nc >= 0 ) then
        nextMatrix[nr,nc] += 1
      end
    end
  end
end

puts("Data Matrix")
displayMatrix(dataMatrix)
puts("")

puts("Next Matrix")
displayMatrix(nextMatrix)
puts("")

puts("Flashed Matrix")
displayMatrix(flashedMatrix)
puts("")

displayMatrix((dataMatrix + nextMatrix) * flashedMatrix)

#newMatrix=dataMatrix[0..rr,0..cc]
#newMatrix += nextMatrix
#displayMatrix(newMatrix)
