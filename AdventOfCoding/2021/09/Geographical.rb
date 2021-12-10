class Geographical

  DEBUG = false

  @@geographical_data={}
  @@min_row=0
  @@max_row=0
  @@min_col=0
  @@max_col=0

  def initialize
    @@geographical_data[:row_width]=0
    @@geographical_data[:raw_data]=[]
    @@geographical_data[:local_minima]={}
    @@geographical_data[:map]={}
  end

  def ingest( lines )
    # :row_width
    # :raw_data
    row=0
    @@geographical_data[:row_width] = lines[0].length
    @@max_col=@@geographical_data[:row_width]
    for line in lines do
      col=0
      @@geographical_data[:raw_data].append(line)
      for v in line.split(//) do
        if @@geographical_data[:map][row] == nil then
          @@geographical_data[:map][row]={}
        end
        @@geographical_data[:map][row][col] = v
        col += 1
      end
      row += 1
    end
    @@max_row=row-1
    @@max_col=@@geographical_data[:row_width]-1
    if DEBUG then
      puts "#{@@geographical_data[:raw_data]}"
    end
  end 

  def display
    for row in 0.upto(@@geographical_data[:map].length) do
      if @@geographical_data[:map][row] != nil then
        for col in 0.upto(@@geographical_data[:map][row].length-1) do
          print " %3d " % [ @@geographical_data[:map][row][col] ]
        end
        puts ""
      end
    end
    #puts "#{@@geographical_data[:map]}"
  end

  def display_with_minima
    for row in 0.upto(@@geographical_data[:map].length) do
      if @@geographical_data[:map][row] != nil then
        for col in 0.upto(@@geographical_data[:map][row].length-1) do
          if is_local_minima?( row,col) then
            print " >%1d< " % [ @@geographical_data[:map][row][col] ]
          else
            print "  %1d  " % [ @@geographical_data[:map][row][col] ]
          end
        end
        puts ""
      end
    end
    #puts "#{@@geographical_data[:map]}"
  end





  def is_local_minima?( target_y,target_x)
    # presume grid is a 3x3 matrix
    # Target spot is in the middle
    valid = true
    neighbors = [ [target_x,target_y-1] , [target_x,target_y+1] , [target_x-1,target_y] , [target_x+1,target_y] ]
    #puts "#{neighbors}"
    #puts @@max_col
    #puts @@max_row
    middle = @@geographical_data[:map][target_y][target_x]
    for (x,y) in neighbors do
      if ( x>=0 ) & ( x<=@@max_col ) then
        if ( y>=0 ) & ( y<=@@max_row ) then
          if @@geographical_data[:map][y][x] != nil then
            if DEBUG then
            puts "(#{x},#{y}) => #{@@geographical_data[:map][y][x]}"
            end
            side=@@geographical_data[:map][y][x]
            if side <= middle then
              valid=false
            end
          end
          #if @@geographical_data[:map][target_y][target_x] >= @@geographical_data[:map][y][x] then
          #  valid = false
          #end
        end
      end
    end
    return valid
  end

end
