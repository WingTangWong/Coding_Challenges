class Octopi

  require 'pp'

  DEBUG=true

  @@grid = {}
  @@step = 0
  @@flashes = 0

  @@rmax=0
  @@cmax=0

  @@step_flashed={}
  @@flash_update=[]

  def initialize( rmax, cmax )
    @@rmax=rmax.to_i - 1
    @@cmax=cmax.to_i - 1
    # Create the 10x10 grid and populate with 0
    for row in 0.upto(@@rmax) do
      @@grid[row]={} 
      for col in 0.upto(@@cmax) do
        @@grid[row][col]=0
      end
    end
    @@step = 0
    @@flashes = 0
    @@step_flashed = {}
    @@flash_update = []
  end


  def ingest( raw_data )
    created=0
    for row in 0.upto(raw_data.length) do
      if raw_data[row] != nil then
        for col in 0.upto(raw_data[row].length) do
          if raw_data[row][col] != nil then
            @@grid[row][col]=raw_data[row][col].to_i
            created += 1
          end
        end
      end
    end
    return created
  end

  def display
    puts ">> Step #{@@step}, flashes #{@@flashes}"
    for row in @@grid.keys.to_a.sort do
      for col in @@grid[row].keys.to_a.sort do
        octopus=@@grid[row][col].to_i 
        if octopus >= 9 then
          print " *%2d* " % [ @@grid[row][col].to_i ] 
        else
          print "  %2d  " % [ @@grid[row][col].to_i ] 
        end
      end
      puts ""
    end
  end


  # Just increment everything by one.
  def do_increment
    for row in @@grid.keys do
      for col in @@grid[row].keys do
        @@grid[row][col] += 1
      end
    end
  end

  def check_flash
    flashes=0
    for row in @@grid.keys do
      for col in @@grid[row].keys do
        if @@grid[row][col] > 9 then
          if !@@step_flashed.include?( [row,col] ) then
            @@flashes += 1
            @@step_flashed.append( [row,col] )
            @@grid[row][col] = 0
            flashes += 1
          end
        end
      end
    end
    return flashes
  end

  def how_many_neighbors_flashed( row, col)
    flashes=0
    for rd in [ -1, 0, 1 ] do
      if @@grid[row + rd] != nil then
        for cd in [ -1, 0, 1] do
          if @@grid[ row + rd][col + cd] != nil then
            if ( rd != 0 ) & ( cd != 0 ) then

            # here, need to determine how many around me flashed, so I can update my count.

            end
          end
        end
      end
    end
    return flashes
  end

  def do_step
    @@step_flashed=[]
    
    do_increment

    todo=1
    while todo > 0 do
      todo=check_flash
    end

    @@step += 1
  end
end
