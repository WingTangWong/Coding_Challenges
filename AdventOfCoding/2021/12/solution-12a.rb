#!/usr/bin/env ruby

DEBUG=false
# Find all paths
#
# [start] = start of cave(origin)
# [end] = end of cave(destination)
# {alpha} = small caves (1 visit max) *cave names can be more than one letter*
# {ALPHA} = big caves (any number of visits) *cave names can be more than one letter*
# "-" = connection between points
#
# EXAMPLE
#   start-A
#   start-b
#   A-c
#   A-b
#   b-d
#   A-end
#   b-end
#
#
#
# RESULTING MAP
#	
#	    start
#	    /   \
#	c--A-----b--d
#	    \   /
#	     end
#	
# RESULTING PATHS
#	
#   start,A,b,A,c,A,end
#   start,A,b,A,end
#   start,A,b,end
#   start,A,c,A,b,A,end
#   start,A,c,A,b,end
#   start,A,c,A,end
#   start,A,end
#   start,b,A,c,A,end
#   start,b,A,end
#   start,b,end
#	
#	"d" is never visited because "b" would end up being visited twice.
#
require 'pp'

WORKING_DATA_FILES=[
  "data/10_paths.txt",
  "data/19_paths.txt",
  "data/226_paths.txt",
  "data/unknown_paths.txt"
]

DATUM={}
MAPS={}
PLACES={}

for target_file in WORKING_DATA_FILES do
  DATUM[target_file]=open(target_file,"r").readlines.map(&:chomp)
  MAPS[target_file]={}
  PLACES[target_file]={}
  for cave_path in DATUM[target_file] do

    path_a=cave_path.split(/-/)[0]
    path_b=cave_path.split(/-/)[1]

    PLACES[target_file][path_a]=0
    PLACES[target_file][path_b]=0

    if MAPS[target_file][path_a] == nil then
      MAPS[target_file][path_a]=[]
    end
    if MAPS[target_file][path_b] == nil then
      MAPS[target_file][path_b]=[]
    end

    if path_b != "start" then
        MAPS[target_file][path_a].append(path_b)
    end
    if path_a != "start" then
        MAPS[target_file][path_b].append(path_a)
    end
  end
  MAPS[target_file].delete("end")
  # Okay have a complete dict of target_file's info
end


if DEBUG then
  puts("===")
  pp(WORKING_SPACE)
  puts("===")
end
# 1. given a starting location, determine all child paths
# 2. need to go down each possible path, IF the potential path -1 doesn't exceed that position's limit.
# 3. if limit exeeds, then this path reaches its end.
# 4. if limit not exceeded, call using this as the starting, along with the path values


def create_weights( map )
  # Assign weights. "end" = 0, lower case places = 1, and upper case places = -1
  # 0 = End of route
  weights = {}
  for m in map.keys do
    if DEBUG then
      puts(m)
    end
    if m.to_s == "end" then
      weights[m] = 0
    elsif m.to_s == m.to_s.downcase then
      weights[m] = 1
    elsif m.to_s == m.to_s.upcase then
        weights[m] = -1
    end
  end
  return weights.dup
end


def do_route( origin, map, route, weights )
  if origin == "start" then
    if DEBUG then
      puts("START")
    end
    @solutions=[]
    # Let's explore each path
    map_weights=create_weights(map)
    if DEBUG then
      pp(map_weights)
    end
    for r in map[origin] do
      route="start"
      weights=map_weights.dup
      if weights[r] != 0 then
        # Is the destination position capable of accepting a visit?
        do_route(r,map,route,weights.dup)
      else
        # Guess not.
        @solutions.append(route)
        return
      end
    end
    return @solutions.dup
  elsif origin == "end" then
    route += ",end"
    @solutions.append(route)
    return 
  else
    # some middle place
    if weights[origin].to_i == 0 then
      # we hit a position that cannot accept anymore visits.
      @solutions.append(route)
      return route 
    else
      # We hit a position that CAN accept more visits
      weights[origin] -= 1
      route += ",%s" % origin.to_s
      for r in map[origin] do
        if map[r] != 0 then
          # Is the destination position capable of accepting a visit?
          do_route(r,map,route,weights.dup)
        else
          # Guess not.
          @solutions.append(routes[r])
          return
        end
      end
    end
  end
end


for target_map in WORKING_DATA_FILES do
  puts("Working on map: %s" % target_map)
  target_start=MAPS[target_map]["start"].dup # Make sure we have the entire "start" entry
  working_space=MAPS[target_map].dup         # Make sure we're not referencing the original
	
	answers=do_route("start",working_space,"",0)
	answers = answers.map { |x| if x.include? "end" then x end} 
	answers.delete(nil)
	if DEBUG then
	  pp(answers)
	  puts(" ")
	end
	
	solu=[
	  "start,A,b,A,c,A,end",
	  "start,A,b,A,end",
	  "start,A,b,end",
	  "start,A,c,A,b,A,end",
	  "start,A,c,A,b,end",
	  "start,A,c,A,end",
	  "start,A,end",
	  "start,b,A,c,A,end",
	  "start,b,A,end",
	  "start,b,end" ]
	
	if DEBUG then
	  pp(solu)
	  puts(" ")
	end
	
	puts("The number of routes is: %d" % answers.count)
	puts(" ")
end
