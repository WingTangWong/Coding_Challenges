#!/usr/bin/env ruby


SRC     = ARGV[0]
fh      = File.open(SRC)
rawdata = fh.readlines.map { | datum | datum.chomp }
max_seat_id=0
seating=[]
for datum in rawdata do
  entry = datum.split(/:/)[0].to_s

  # Simpler and faster method
  entry_bit_value=entry.gsub("B","1").gsub("F","0").gsub("R","1").gsub("L","0")
  row_bit_value = entry_bit_value[0..6]
  col_bit_value = entry_bit_value[7..9]
  seat_row = row_bit_value.to_i(2)
  seat_col = col_bit_value.to_i(2)
  seat_id  = ( seat_row * 8 ) + seat_col
  seating.append(seat_id)
  if seat_id > max_seat_id then
    max_seat_id = seat_id
  end

  # puts "[ %s ] => [ ROW  %5d ] [ COL %3d ] => SEAT ID [ %3d ]" % [ datum , seat_row, seat_col , seat_id ]
end

sorted_seats=seating.sort
prev_seat=sorted_seats[0]
puts "#{sorted_seats[1..-1]}"
for seat in seating.sort[1..-1] do
  if (seat - prev_seat) > 1 then
    puts "Spot between #{prev_seat} and #{seat}"
  end
  prev_seat=seat
end
