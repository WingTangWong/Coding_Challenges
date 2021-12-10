class Geographical

  DEBUG = false

  @@geographical_data={}
  @@min_row=0
  @@max_row=0
  @@min_col=0
  @@max_col=0
  @@minimas=[]
  @@current_basin=1000

  def initialize
    @@geographical_data[:row_width]=0
    @@geographical_data[:raw_data]=[]
    @@geographical_data[:local_minima]={}
    @@geographical_data[:map]={}
    @@current_basin=1000
  end

  def max_row
    return @@max_row.to_i
  end

  def max_col
    return @@max_col.to_i
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

  def display ( field_size = 1 )
    ff="%#{field_size}s" 
    for row in 0.upto(@@geographical_data[:map].length) do
      if @@geographical_data[:map][row] != nil then
        for col in 0.upto(@@geographical_data[:map][row].length-1) do
          if @@geographical_data[:map][row][col] != nil then
            print ff % [ @@geographical_data[:map][row][col] ]
          else
            print ff % [" "]
          end
        end
        puts ""
      end
    end
    #puts "#{@@geographical_data[:map]}"
  end

  def display_with_minima
    tally=0
    for row in 0.upto(@@geographical_data[:map].length) do
      if @@geographical_data[:map][row] != nil then
        for col in 0.upto(@@geographical_data[:map][row].length-1) do
          if is_local_minima?( row,col) then
            print " >%1d< " % [ @@geographical_data[:map][row][col].to_i ]
            tally += @@geographical_data[:map][row][col].to_i + 1
          else
            print "  %1d  " % [ @@geographical_data[:map][row][col] ]
          end
        end
        puts ""
      end
    end
    puts "Tally: %d" % [ tally ]
    #puts "#{@@geographical_data[:map]}"
  end


  def is_local_minima?( target_y,target_x)
    # Given Y,X positions...
    # Determine which positions around it we need to get readings of.
    # If any of the positions are <= to the target position, then this isn't a lowest point.
    #
    valid = true
    neighbors = [ [target_x,target_y-1] , [target_x,target_y+1] , [target_x-1,target_y] , [target_x+1,target_y] ]
    middle = @@geographical_data[:map][target_y][target_x]
    for (x,y) in neighbors do
      if ( x>=0 ) & ( x<=@@max_col ) then
        if ( y>=0 ) & ( y<=@@max_row ) then
          # Test to see if the neighbor position is outside of the map. No fault
          # but also nothing to act on.
          if @@geographical_data[:map][y][x] != nil then
            if DEBUG then
            puts "(#{x},#{y}) => #{@@geographical_data[:map][y][x]}"
            end
            side=@@geographical_data[:map][y][x].to_i
            # Yep. Anything smaller than or equal to the target point is invalid
            if side <= middle.to_i then
              valid=false
            end
          end
        end
      end
    end
    if valid then
      @@minimas.append([target_y,target_x])
    end
    return valid
  end

  # Hmm... this removes all of the nines and displays in a way that 
  # is easy to see the basins
  #
  #  ###############################
  #  # 2  1 ######### 4  3  2  1  0#
  #  # 3 ### 8  7  8 ### 4 ### 2  1#
  #  #### 8  5  6  7  8 ### 8 ### 2#
  #  # 8  7  6  7  8 ### 6  7  8 ###
  #  #### 8 ######### 6  5  6  7  8#
  #  ###############################
  #
  #  Looks like we now need to find a way of
  #  grouping the basin points together.
  #
  def remove_nines
    for row in 0.upto(@@geographical_data[:map].length) do
      if @@geographical_data[:map][row] != nil then
        for col in 0.upto(@@geographical_data[:map][row].length-1) do
          if @@geographical_data[:map][row][col].to_i < 9 then
            if DEBUG then
              print " %1d " % [ @@geographical_data[:map][row][col] ]
            end
          else
            # Remove 9's.
            @@geographical_data[:map][row][col]=nil
            if DEBUG then
              print "#%1s#" % [ "#" ]
            end
          end
        end
        if DEBUG then
          puts ""
        end
      end
    end
  end

  def get_minimas
    return @@minimas.to_a
  end

  def fill_touching( row, col )
    # Given a starting location... continue to explore until all unflagged spaces are flagged.
    todo=[]
    todo.append([row,col])
    visited=[]
    not_wall=[]

    while (todo.length > 0) do
      (r,c) = todo.shift
      todo = todo.sort.uniq
      visited = visited.sort.uniq
      r = r.to_i
      c = c.to_i
      visited.append([r,c])
      
      # up
      if ( r-1 ) >= 0 then
        if !visited.include?([r-1,c]) then
          if ( @@geographical_data[:map][r-1][c] == nil  ) | ( @@geographical_data[:map][r-1][c].to_i == 9) then
            visited.append([r-1,c])
          else
            todo.append([r-1,c])  
          end
        end
      end

        # down
      if ( r+1 ) <= @@max_row then
        if !visited.include?([r+1,c]) then
          if ( @@geographical_data[:map][r+1][c] == nil  ) | ( @@geographical_data[:map][r+1][c].to_i == 9) then
            visited.append([r+1,c])
          else
            todo.append([r+1,c])  
          end
        end
      end

        # left
      if ( c-1 ) >= 0 then
        if !visited.include?([r,c-1]) then
          if ( @@geographical_data[:map][r][c-1] == nil  ) | ( @@geographical_data[:map][r][c-1].to_i == 9) then
            visited.append([r,c-1])
          else
            todo.append([r,c-1])  
          end
        end
      end

        # right
      if ( c+1 ) <= @@max_col  then
        if !visited.include?([r,c+1]) then
          if ( @@geographical_data[:map][r][c+1] == nil  ) | ( @@geographical_data[:map][r][c+1].to_i == 9) then
            visited.append([r,c+1])
          else
            todo.append([r,c+1])  
          end
        end
      end

      # Okay, what are WE?
      if !( @@geographical_data[:map][r] == nil ) && !( @@geographical_data[:map][r][c] == nil ) then
        if (( @@geographical_data[:map][r][c].to_i >= 0 ) & ( @@geographical_data[:map][r][c].to_i <= 8 )) then
          not_wall.append([r.to_i,c.to_i])
        end
      end
      #puts ">> Todo    = #{todo.length} :: #{todo}"
      #puts ">> Visited = #{visited.length} :: #{visited}"
      #puts ">> Not Wall= #{not_wall.length}"

      if visited.length > ( @@max_row * @@max_col ) then
        puts "Visisted is too high! Something broke!"
        exit
      end
    end
    visited=visited.sort.uniq
    not_wall=not_wall.sort.uniq
    puts ">> Visited [ #{visited.length} ] / Not Wall [ #{not_wall.length} ]"
    return not_wall.length
  end
end
