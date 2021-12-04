# The Giant Squid Bingo

[AOC 2021](https://adventofcode.com/2021/day/4)

Deep deep under the sea... and we are going to play bingo...?

## 1st half

Given a file with bingo drawings... and a list of board matrices... determine which board wins with the least drawings.
Calculate the board's score by summing all the unmarked squares and multiplying the sum by the value of the last ball drawn.

## 2nd half

Now do the opposite. Find out which one took the most draws and then take the sum of unmarked and multiply it against the last
ball drawn for that winning board.

## Notes

* I implemented a check for diagonal winning state when I didn't need to. ugh. 
* DEBUG tests REALLY helps to figure out what is going on... and what went wrong.

