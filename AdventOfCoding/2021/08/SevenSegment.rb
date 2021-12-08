class SevenSegment
  require 'pp'
  DEBUG=false
  #  #   0:      1:      2:      3:      4:
  #   aaaa    ....    aaaa    aaaa    ....
  #  b    c  .    c  .    c  .    c  b    c
  #  b    c  .    c  .    c  .    c  b    c
  #   ....    ....    dddd    dddd    dddd
  #  e    f  .    f  e    .  .    f  .    f
  #  e    f  .    f  e    .  .    f  .    f
  #   gggg    ....    gggg    gggg    ....
  #  
  #    5:      6:      7:      8:      9:
  #   aaaa    aaaa    aaaa    aaaa    aaaa
  #  b    .  b    .  .    c  b    c  b    c
  #  b    .  b    .  .    c  b    c  b    c
  #   dddd    dddd    ....    dddd    dddd
  #  .    f  e    f  .    f  e    f  .    f
  #  .    f  e    f  .    f  e    f  .    f
  #   gggg    gggg    ....    gggg    gggg



  # "1" = 2 segments
  # "7" = 3 segments
  # "8" = 7 segments, all segments are lit.
  # what is in "3" but not in "2"(5segments) = [f]
  # what is in "9" but not in "3"(5segments) = [b]
#
  # 3
  # 4
  # 5
  # what is in "6" but not in "5"(5segment) = [e]
  # what is in "8" but not in "6"(6segments) = [c] 
  # What is in "8" but not in "9"(6segments) = [e]
  # What is in "8" but not in "0"(6segments) = [d]

  @@default_segments_to_digits = {}
  @@default_digits_to_segments = {}
  @@segments_to_digits = {}
  @@digits_to_segments = {}
  @@permutations = {}
  @@permutations[0] = []
  @@permutations[1] = []
  @@permutations[2] = []
  @@permutations[3] = []
  @@permutations[4] = []
  @@permutations[5] = []
  @@permutations[6] = []
  @@permutations[7] = []
  @@permutations[8] = []
  @@permutations[9] = []

  @@bylength={} 
  @@bylength[7]=[]
  @@bylength[6]=[]
  @@bylength[5]=[]
  @@bylength[4]=[]
  @@bylength[3]=[]
  @@bylength[2]=[]

  @@translation={}
  @@translation["a"]="x"
  @@translation["b"]="x"
  @@translation["c"]="x"
  @@translation["d"]="x"
  @@translation["e"]="x"
  @@translation["f"]="x"
  @@translation["g"]="x"

  def initialize
    # Default segment conversion...
    @@default_digits_to_segments["0"] = "abcefg"
    @@default_digits_to_segments["1"] = "cf"
    @@default_digits_to_segments["2"] = "acdeg"
    @@default_digits_to_segments["3"] = "acdfg"
    @@default_digits_to_segments["4"] = "bcdf"
    @@default_digits_to_segments["5"] = "abdfg"
    @@default_digits_to_segments["6"] = "abdefg"
    @@default_digits_to_segments["7"] = "acf"
    @@default_digits_to_segments["8"] = "abcdefg"
    @@default_digits_to_segments["9"] = "abcdfg"


    @@default_segments_to_digits["abcefg"]  = "0"
    @@default_segments_to_digits["cf"]      = "1"
    @@default_segments_to_digits["acdeg"]   = "2"
    @@default_segments_to_digits["acdfg"]   = "3"
    @@default_segments_to_digits["bcdf"]    = "4"
    @@default_segments_to_digits["abdfg"]   = "5"
    @@default_segments_to_digits["abdefg"]  = "6"
    @@default_segments_to_digits["acf"]     = "7"
    @@default_segments_to_digits["abcdefg"] = "8"
    @@default_segments_to_digits["abcdfg"]  = "9"
  end

  def ingest( cipher )
    # Receive a set of 10 words that are the alphabet
    segments = cipher.split(/ /).map { |x| x.to_s.split(//).to_a.sort }

    # Take care of the digits with known lengths
    for lengths in segments do
      @@bylength[lengths.length].append(lengths)
  
      if lengths.length == 2 then
        # "1" has only 2 segments.
        @@segments_to_digits["1"]=lengths
      end

      if lengths.length == 3 then
        # "7" has only 3 segments.
        @@segments_to_digits["7"]=lengths
      end

      if lengths.length == 4 then
        # "7" has only 3 segments.
        @@segments_to_digits["4"]=lengths
      end

      if lengths.length == 7 then
        # "8" has all 7 segments.
        @@segments_to_digits["8"]=lengths
      end
    end

    # Can we infer what the translation is?
    #
    # 1 and 7 share 2 of 3. The extra in 7 is "a"
    @@translation[ (@@segments_to_digits["7"] - @@segments_to_digits["1"]).sort.join]="a"

    # Handle 5 chara letters
    #
    # 2 = 5 chara
    # 3 = 5 chara
    # 5 = 5 chara
    # 
    # 2,3,5 have a,d,g in common
    adg = @@bylength[5][0] & @@bylength[5][1] &  @@bylength[5][2]

    # Remove adg, and you have 2 chara per. the ones with 1 in common are c,f. 
    a=@@bylength[5][0] - adg
    b=@@bylength[5][1] - adg
    c=@@bylength[5][2] - adg

    d=@@bylength[4][0] - adg

    if ( a - b ).length == 2 then
      @@segments_to_digits["3"] = @@bylength[5][2].sort
      ft=[ @@bylength[5][0] , @@bylength[5][1] ]
      # a and b are "2" and "5"
      # 3 == c
    end
    
    if ( a - c ).length == 2 then
      @@segments_to_digits["3"] = @@bylength[5][1].sort
      ft=[ @@bylength[5][0] , @@bylength[5][2] ]
      # 3 == b
    end

    if ( b - c ).length == 2 then
      @@segments_to_digits["3"] = @@bylength[5][0].sort
      ft=[ @@bylength[5][2] , @@bylength[5][1] ]
      # 3 == a
    end

    # Figured out which coded letter is 'b'
   @@translation[ (d-@@segments_to_digits["3"]).join ] = "b"

   # Let's figure out which is 5... the other will be 2
   
   if ( ft[0]  -  @@translation.key("b").split(//) ).length < 5 then
     @@segments_to_digits["5"] = ft[0]
     @@segments_to_digits["2"] = ft[1]
   else
     @@segments_to_digits["5"] = ft[1]
     @@segments_to_digits["2"] = ft[0]
   end

   # Woot! Done figuring out 2,3,5... the 5 segment ones.
   #
   # Now... to do the 6 segment ones.
   # 6,9,0
   # These have "adgbf" in common.
   four_one_b = @@segments_to_digits["4"] - @@segments_to_digits["1"] - [@@translation.key("b")]

   @@translation[ four_one_b.join]="d"

   adgbf = @@bylength[6][0] & @@bylength[6][1] &  @@bylength[6][2]
 
   # 0 - ( 3 + 4 ) = 1 segment left.
    #puts four_one_b
    #puts "#{@@bylength[6][0]} & #{@@bylength[6][1]} &  #{@@bylength[6][2]}"
    a=@@bylength[6][0] 
    b=@@bylength[6][1]
    c=@@bylength[6][2]

    # If we remove 1 and b from 4, that leaves the middle bar
    if ( a - four_one_b ).length == 6 then
      @@segments_to_digits["0"] = a
      ft=[b,c]
    end
    if ( b - four_one_b ).length == 6 then
      @@segments_to_digits["0"] = b
      ft=[a,c]
    end
    if ( c - four_one_b ).length == 6 then
      @@segments_to_digits["0"] = c
      ft=[a,b]
    end
 
    one_b = @@segments_to_digits["1"] + [@@translation.key("b")]

    if ( ft[0] - one_b ).length == 3 then
      @@segments_to_digits["9"] = ft[0]
      @@segments_to_digits["6"] = ft[1]
    else
      @@segments_to_digits["9"] = ft[1]
      @@segments_to_digits["6"] = ft[0]
    end


    if DEBUG then
    puts ">>> Conversion <<<"
    @@translation.keys.map { |x| puts "#{x} => #{@@translation[x]}" }
    #puts "bylength"
    #pp @@bylength
    puts "segments_to_digits"

    for key in @@segments_to_digits.keys.sort  do
      print "#{key} :: "
      for aa in "a".."g" do
        if @@segments_to_digits[key].include?(aa) then
          print " #{aa} "
        else
          print " . "
        end
      end
      puts ""
    end
    end
  end

  def to_segments( digit )
    return @@segments_to_digits[ digit.to_s ]
  end

  def to_digit( segments)
    if DEBUG then
      puts segments
    end
    return @@segments_to_digits.key( segments.split(//).sort )
  end

end
