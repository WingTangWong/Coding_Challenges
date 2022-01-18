#!/usr/bin/env ruby
class FlashMap

  @@grid=[]
  @@step=0
  @@flashes=[]

  def ingest( datum )
    if DEBUG then
      puts "INGEST"
    end
    # If you are ingesting, then you are wiping out previous state
    @@grid=[]
    # Assumes datum is a 2D array of rows and columns
    for row in 0.upto(datum.length-1) do
      if @@grid[row] == nil then
        @@grid[row]=[]
      end
      for col in 0.upto(datum[row].length-1) do
        @@grid[row].append(datum[row][col].to_i)
      end
    end
  end

  def inc_all
    if DEBUG then
      puts "INC_ALL"
    end
    @@step += 1
    for row in 0.upto(@@grid.length-1) do
      for col in 0.upto(@@grid[row].length-1) do
        @@grid[row][col] += 1
        if @@grid[row][col] == 10 then
          @@flashes.append( [row,col] )
        end
      end
    end
  end

  def change_state( src, dst )
    if DEBUG then
      puts "CHANGE_STATE"
    end
    changed = 0
    for row in 0.upto(@@grid.length-1) do
      for col in 0.upto(@@grid[row].length-1) do
        if @@grid[row][col] == src then
          @@grid[row][col] == dst
          changed += 1
        end
      end
    end
    return changed
  end

  # Let's update the neighbors of a flash point
  def emit_flash
    secondary_flash=0
    new_flashes=[]
    new_map={}
    if DEBUG then
      print "Flash Queue: ",@@flashes.length
      puts ""
    end
    for row,col in @@flashes do
      for r in [ -1, 0, 1] do
        if new_map[r] == nil then
          new_map[r]={}
        end
        for c in [-1, 0, 1] do
          if new_map[r][c] == nil then
            new_map[r][c]=0
          end
          # don't process center...
          if ( [r,c] != [0,0] ) then
                # don't increment if above 9
                if @@grid[row+r] != nil then
                  if @@grid[row+r][col+c] != nil then
                    if ( @@grid[row+r][col+c] <= 9 ) & ( @@grid[row+r][col+c] > 0 ) then
                      @@grid[row+r][col+c] += 1 
                      new_map[row+r][col+c] += 1
                      if @@grid[row+r][col+c] == 10 then
                        @@grid[row+r][col+c]=100
                        secondary_flash += 1
                        new_flashes.append([row+r,col+c])
                      end
                    end
                  end
                end
          end
        end
      end
    end
    #if secondary_flash > 0 then
    emit_flash
    #end

    # Okay, no more secondary flashes...
    # New flashes go to state of flashes of inc_all
    clean_flashes 
  end

  def clean_flashes
    for row in 0.upto(@@grid.length - 1) do
      for col in 0.upto(@@grid[0].length - 1) do
        if @@grid[row][col] >= 10 then
          @@grid[row][col] = 0
        end
      end
    end
  end

  def display
    if DEBUG then
      puts "DISPLAY"
    end
    print "Step: "
    puts @@step
    for row in 0.upto(@@grid.length-1) do
      for col in 0.upto(@@grid[row].length-1) do
        cel = @@grid[row][col]
        if cel == -1 then
          print " _f_ "
        end
        if cel == 10 then
          print " [F] "
        end
        if cel > 10 then
          print " [!] "
        end
        if ((cel >= 1) & (cel <= 9)) then
          print " [#{cel}] "
        end
        if cel == 0 then
          print " [0] "
        end
      end
      puts " "
    end
  end

  def do_step
    if DEBUG then
      puts "DO_STEP"
    end
    if DEBUG then
      display
    end
    # Let's increment all by one
    inc_all
    if ( @@flashes.length > 0 ) | ( @@flashes != nil ) then
      emit_flash
    end
  end
end
