#!/usr/bin/env ruby
DEBUG=true
require 'matrix'

#
# Squid Bingo....
#
#
#  7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
#  
#  22 13 17 11  0
#   8  2 23  4 24
#  21  9 14 16  7
#   6 10  3 18  5
#   1 12 20 15 19
#  
#   3 15  0  2 22
#   9 18 13 17  5
#  19  8  7 25 23
#  20 11 10 24  4
#  14 21 16 12  6
#  
#  14 21 17 24  4
#  10 16 15  9 19
#  18  8 23 26 20
#  22 11 13  6  5
#   2  0 12  3  7
#
# The score of the winning board can now be calculated. Start by finding the 
# sum of all unmarked numbers on that board; in this case, the sum is 188. 
#
# score1 = sum of all unmarked positions
#
# Then, multiply that sum by the number that was just called when the board 
# won, 24, to get the final score, 188 * 24 = 4512.
#
# score2 = last number drawn x score1
#
params=ARGV

if params.count < 1 then
  puts "Require a source file."
  exit
end

file = File.open(params[0])

raw_data = file.readlines.map(&:chomp)

# So, first line represents the numbers drawn.
#
# subsequent lines are the boards... with a board end designated by a blank line.
# board positions seperated by a number of whitespaces
#
# So, I can either approach it by creating a matrix for all boards and then processing them all in turn....
# Or I can determine the winning score as I go, ie, one shot. 

drawn_numbers=raw_data[0].split(/,/)
min_win_steps=drawn_numbers.count + 1
# first, let's read in the matrix...
raw_idx = 1

def has_winner( board )
  # Accepts a Matrix
  board_win=false
  d = board.column_count
  diag_r=[]
  diag_l=[]
  for p in 0..(d-1) do
    # Test column
    if board.column(p).to_a.join == "XXXXX" then
      board_win=true
    end
    # Test row
    if board.row(p).to_a.join == "XXXXX" then
      board_win=true
    end
    # Test diagonals
    diag_r.append(board[p,p])
    diag_l.append(board[(d-1)-p,p])
  end

  if diag_r.join == "XXXXX" then
    board_win=true
  end

  if diag_l.join == "XXXXX" then
    board_win=true
  end

  return board_win
end


def tally_board ( board )
  tally = 0
  for p in board do
    tally += p.to_i
  end
  return tally
end

min_board_score=0
while raw_idx < raw_data.count do
	board_score=0
	pre_board=[]
	# Read until index points to start of board record
	while ( raw_data[raw_idx] != nil) do
    if raw_data[raw_idx].length < 3 then
	    raw_idx += 1
    else
      break
    end
	end
  puts raw_idx	
	# Assemble up current board until end of board record
	while ( raw_data[raw_idx] != nil) do
    if raw_data[raw_idx].length > 3 then
	    pre_board.append( raw_data[raw_idx] )
	    raw_idx += 1
    else
	    raw_idx += 1
	    break
    end
	end
	
	# Convert board to a matrix, clean up white space
	board=pre_board.map { |rr| rr.lstrip.rstrip.gsub("  "," ").split(/ /) }
	board_matrix=mat = Matrix[ *board ]
	# Determine how many steps to get bingo... and resulting score
	draws_to_win=0
	found_winner=false
	for drawing in drawn_numbers do
	  draws_to_win += 1
	  new_matrix = board_matrix.map { |x| x == drawing ? "X" : x }
	  if has_winner(new_matrix) then
	    found_winner=true
	    if draws_to_win <  min_win_steps then
	      min_win_steps = draws_to_win
	      min_board_score = tally_board(new_matrix)
	    end
	    break
	  end
	  board_matrix=new_matrix.clone
	  if DEBUG then
	    puts ">> Draw#[#{draws_to_win}] :: Drew [ #{drawing} ] ::  Winner [ #{found_winner} ] :: Board Score [ #{board_score} ]"
	  end
	end
	
	if DEBUG then
	  puts ">> Draw#[#{draws_to_win}] :: Drew [ #{drawing} ] ::  Winner [ #{found_winner} ] :: Board Score [ #{board_score} ]"
	end
	
end

