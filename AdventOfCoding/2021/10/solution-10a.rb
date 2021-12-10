#!/usr/bin/env ruby
# 
# Syntax errors.... detect and maybe fix matching brackets...
#
# If a chunk opens with (, it must close with ).
# If a chunk opens with [, it must close with ].
# If a chunk opens with {, it must close with }.
# If a chunk opens with <, it must close with >.

# First illegal character determines the score.
#
#  ): 3 points.
#  ]: 57 points.
#  }: 1197 points.
#  >: 25137 points.

# Examples:
#
# {([(<{}[<>[]}>{[]{[(<()> - Expected ], but found } instead.
# [[<[([]))<([[{}[[()]]] - Expected ], but found ) instead.
# [{[{({}]{}}([{[{{{}}([] - Expected ), but found ] instead.
# [<(<(<(<{}))><([]([]() - Expected >, but found ) instead.
# <{([([[(<>()){}]>(<<{{ - Expected ], but found > instead.

DEBUG=true
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
  '(' => 3,
  ')' => 3,
  ']' => 57,
  '[' => 57,
  '}' => 1197,
  '{' => 1197,
  '>' => 25137,
  '<' => 25137 }


if PARAMS.length < 1 then
  puts "Missing file"
  exit
end

raw_data=File.open(PARAMS[0]).readlines.map(&:chomp)

state_machine=[]

for line in raw_data do
  state_machine=[]
  symbol_stack=[]
  for symbol in line.split(//) do
    if symbol_open.include?( symbol ) then
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
        break
      end
    end
  end
  if DEBUG then
    puts ":::"
  end
end
puts "Final Score for error: #{score_tally}"
