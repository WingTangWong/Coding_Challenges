# Deep Sea Cave Syntax Errors....

[AOC 2021 - Day 10](https://adventofcode.com/2021/day/10)


## 1st Half

....


If a chunk opens with (, it must close with ).
If a chunk opens with [, it must close with ].
If a chunk opens with {, it must close with }.
If a chunk opens with <, it must close with >.

For each symbol, there is a score...

yeah.... need to remove the non-conformant lines from the dataset

### approach

* maintain a stack to "push" in opening symbols and "pop" out a most recent if there is a closing symbol. If they are of the same kind, good. If not, error!
* Tally score as you go, and should have a complete value at the end.

## 2nd Half


