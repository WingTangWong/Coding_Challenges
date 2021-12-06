# Airplane Boarding Pass... Seat Decoder

[AOC 2020](https://adventofcode.com/2020/day/5)

SUMMARY

Decode boarding passes...

  BFFFBBFRRR: row 70, column 7, seat ID 567.
  FFFBBBFRRR: row 14, column 7, seat ID 119.
  BBFFBBFRLL: row 102, column 4, seat ID 820.

## 1st half

128 rows of seats in the plane...

For example, consider just the first seven characters of FBFBBFFRLR:

Start by considering the whole range, rows 0 through 127.
F means to take the lower half, keeping rows 0 through 63.
B means to take the upper half, keeping rows 32 through 63.
F means to take the lower half, keeping rows 32 through 47.
B means to take the upper half, keeping rows 40 through 47.
B keeps rows 44 through 47.
F keeps rows 44 through 45.
The final F keeps the lower of the two, row 44.


## 2nd half

PROBLEMDESC2

## Notes

* ISSUES
* ISSUES
* ISSUES
