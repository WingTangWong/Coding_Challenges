#!/usr/bin/env ruby
# 
# Ignore lines with syntax errors.
# For lines that are incomplete, determine sequence to complete
# With the symbols, starting with a tally of 0:
#
# tally += (5 * tally ) + symbol value
#
#
# First illegal character determines the score.
#
# ): 1 point.
# ]: 2 points.
# }: 3 points.
# >: 4 points.
#

DEBUG=false
PARAMS=ARGV

symbol_open=[ '(', '[', '{' , '<' ]
symbol_close=[ ')', ']', '}', '>' ]
symbol_stack=[]
symbol_pair={}
symbol_pair[')']='('
symbol_pair[']']='['
symbol_pair['}']='{'
symbol_pair['>']='<'
score_tally=0

symbol_score={
  '(' => 1,
  ')' => 1,
  ']' => 2,
  '[' => 2,
  '}' => 3,
  '{' => 3,
  '>' => 4,
  '<' => 4}


if PARAMS.length < 1 then
  puts "Missing file"
  exit
end

raw_data=File.open(PARAMS[0]).readlines.map(&:chomp)

state_machine=[]
all_scores=[]

for line in raw_data do
  completion_score=0
  state_machine=[]
  symbol_stack=[]
  corrupted=false
  for symbol in line.split(//) do
    if symbol_open.include?( symbol ) then
      puts "#{symbol_stack.join} :: #{symbol} "
      if DEBUG then
        print "+#{symbol} "
      end
      symbol_stack.append(symbol)
      if DEBUG then
        print "#{symbol_stack.length} "
      end
    end
    if symbol_close.include?( symbol ) then
      if symbol_stack.length == 0 then
        puts "Stack empty. Cannot pop #{symbol}"
        next
      end
      if DEBUG then
        print "-#{symbol} "
      end
      symbol_prev=symbol_stack.pop


      if DEBUG then
        print "#{symbol_stack.length} "
        print "#{symbol_pair[symbol]} "
        print "#{symbol_pair[symbol_prev]} "
      end
      if symbol_pair[symbol] != symbol_prev then
        print "BREAK '#{symbol}' came up. '#{symbol_pair[symbol]}' != '#{symbol_prev}' "
        print "SCORE[#{symbol_score[symbol]}]"
        score_tally += symbol_score[symbol]
        corrupted=true
        break
      end
    end
  end

  if !corrupted then
    while symbol_stack != nil do
      current=symbol_stack.pop
      if current != nil
        completion_score = ( completion_score * 5 ) + symbol_score[current]
      else
        break
      end
    end
    puts ">> Completion Score = #{completion_score}"
    all_scores.append( completion_score.to_i )
  end
  if DEBUG then
    puts ":::"
  end
end
score_count=all_scores.length
middle=(score_count / 2 ) 
puts "Final Score for error: #{score_tally}"
puts "All completion scores: #{ all_scores }"
puts "All completion scores: #{ all_scores.sort }"
puts "Middle Score: #{ all_scores.sort[middle]}"
