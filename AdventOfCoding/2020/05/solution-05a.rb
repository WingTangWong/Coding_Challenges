#!/usr/bin/env ruby

SRC     = ARGV[0]
fh      = File.open(SRC)
rawdata = fh.readlines.map { | datum | datum.chomp }
max_seat_id=0
for datum in rawdata do
  entry = datum.split(/:/)[0].to_s

  # Simpler and faster method
  entry_bit_value=entry.gsub("B","1").gsub("F","0").gsub("R","1").gsub("L","0")
  row_bit_value = entry_bit_value[0..6]
  col_bit_value = entry_bit_value[7..9]
#    bit_pos=0
#    row_bit_value="0000000"
#    col_bit_value="000"
#    for c in datum.each_char.map do
#      bit=0
#      if c == "F" then
#        bit = 0
#      end
#      if c == "B" then
#        bit = 1
#      end
#      if c == "L" then
#        bit = 0
#      end
#      if c == "R" then
#        bit = 1
#      end
#      if bit_pos <= 6 then
#        row_bit_value[bit_pos]=bit.to_s
#      else
#        col_bit_value[bit_pos - 6]=bit.to_s
#      end
#      bit_pos += 1
#    end
  seat_row = row_bit_value.to_i(2)
  seat_col = col_bit_value.to_i(2)
  seat_id  = ( seat_row * 8 ) + seat_col
  if seat_id > max_seat_id then
    max_seat_id = seat_id
  end
  puts "[ %s ] => [ ROW  %5d ] [ COL %3d ] => SEAT ID [ %3d ]" % [ datum , seat_row, seat_col , seat_id ]
end

puts max_seat_id
