# Day 14, polymerization

The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

# Example

  NNCB
  
  CH -> B
  HH -> N
  CB -> H
  NH -> C
  HB -> C
  HC -> B
  HN -> C
  NN -> C
  BH -> H
  NC -> B
  NB -> B
  BN -> B
  BB -> N
  BC -> B
  CC -> N
  CN -> C

# Rules/Interpretation

* The first line is the polymer template - this is the starting point of the process.
* The following section defines the pair insertion rules: 
  * A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them. 
  * These insertions all happen simultaneously.


# For NNCB

1. Step #1 takes into consideration the following three rules simultaneously:
  * The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
  * The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
  * The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.
  * Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

# Results

  Template:     NNCB
  After step 1: NCNBCHB
  After step 2: NBCCNBBBCBHCB
  After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
  After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB

