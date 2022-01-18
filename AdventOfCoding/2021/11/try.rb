#!/usr/bin/env ruby
# 

require 'nmatrix'

DEBUG=false

PRACTICE1="data/sample.txt"
PRACTICE2="data/sample2.txt"
REAL_DATA="data/prod.txt"

DATUM=open(PRACTICE2,"r").readlines.map(&:chomp)

ROWS=DATUM[0].length
COLS=DATUM.count
RR = ROWS-1
CC = COLS-1

dataMatrix=NMatrix.new([ROWS,COLS])

validRows=0..RR
validRows=validRows.to_a
validCols=0..CC
validCols=validCols.to_a

for row in 0..RR
  DATUM[row] = DATUM[row].split(//)
  for col in 0..CC
    dataMatrix[row,col] = DATUM[row][col].to_i
  end
end

$total_flashes=0


step=0
# Okay, the rules of the state machines...
# 1. Energy level at each position = 0 through 9
# 2. At the start of each step, all positions increase energy by 1
# 3. After the increase, anything with a value > 9, flashes.
#    * Flashes increase the energy of all adjacent positions by one.
#    * Each octopus can only flash once per step.
# 4. Any octopus that has flashed, the energy gets set to 0

def displayMatrix( m )
  for r in 0..RR do
    for c in 0..CC do
      print(" %3d " % m[r,c])
    end
    puts("")
  end
end



def stepMatrix( m )
  nextMatrix=NMatrix.new([ROWS,COLS],0)
  flashedMatrix=NMatrix.new([ROWS,COLS], 1)
	# STEP START
	if DEBUG then
    displayMatrix(m)
    puts("")
  end
	# 1. Increase all by 1
	m[0..RR,0..CC] += 1
	if DEBUG then
    puts(">> +1")
    displayMatrix(m)
    puts("")
  end
	
	
	if DEBUG then
	  puts(">> If >9, flash")
  end	

	while true do
		# Let's determine which ones flashed.
		flash_count=0
		todo=[]
		for r in 0..RR do
		  for c in 0..CC do
		    if m[r,c] > 9 then
		      if flashedMatrix[r,c] > 0 then
		        flash_count += 1
		        $total_flashes += 1
		        todo.append([r,c])
		      end 
		      flashedMatrix[r,c]=0
		    end
		  end
		end
	  
	  if flash_count == 0 then
	    if DEBUG then
	      puts("Left loop")
      end
	    break
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
		    if ( nr <= RR ) & ( nr >= 0 ) then
		      if ( nc <= CC ) & ( nc >= 0 ) then
		        nextMatrix[nr,nc] += 1
		      end
		    end
		  end
		end
	
	    if DEBUG then
        puts("Data Matrix")
        displayMatrix(m)
        puts("")
        
        puts("Next Matrix")
        displayMatrix(nextMatrix)
        puts("")
        
        puts("Flashed Matrix")
        displayMatrix(flashedMatrix)
        puts("")
      end
	  m = ( ( m + nextMatrix) * flashedMatrix )
	  nextMatrix[0..RR,0..CC]=0
	end	

    if DEBUG then
      displayMatrix(m)
      puts("")
    end
	  return m
  end



step = 0
STEP_END=10
DEBUG=true
while step < STEP_END do
  if DEBUG then
    puts("[Step %d] Matrix State" % step)
  end
  dataMatrix=stepMatrix( dataMatrix )
  if DEBUG then
    displayMatrix(dataMatrix)
  end
  step += 1
end

puts("Total flashes: %s" % $total_flashes)



