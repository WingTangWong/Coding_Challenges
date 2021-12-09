# 7 segment displays...

So there is some segment wiring miswiring. Ouch.

Need to fix that and properly display the numbers that should be represented.


# 1st Half - Fix the translation and get a count of how often certain numbers come up

* So I wrote a class called `SevenSegment`.
* Initializes a default set of mappings, but does not use them. Just for reference.
* An `ingest` method to take in the 10 messed up entries and during ingestion, performs
  some dynamic 7 segment process of elimination to determine which grouping of segment letters
  represents which actual number. This is done with the assumption of a 7 segment display and a
  fixed "font".
* Once `ingest` completes, I will have the encoding required to fix the output and get the number.
* Note, my solution, which calls the class, assumes that each line is potentially messed up in a unique way.
  So if the "encoding" differs from line to line, my solution will still properly interpret the values at the end of the line.
* Final count done through an array.tally and then summing what was found.


# 2nd Half - Summation....

* Found that my original code in the first half has an initialization bug. Fixing this ensures the numbers are properly decoded.
* Kinda amazed it worked for the 1st half, considering. :/
