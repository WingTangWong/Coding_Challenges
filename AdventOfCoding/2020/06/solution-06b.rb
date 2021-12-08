#!/usr/bin/env ruby

SRC     = ARGV[0]
fh      = File.open(SRC)

rawdata = fh.readlines.map(&:chomp)

didx=0
gidx=0


datum=""
while didx <= rawdata.length do
  datum += rawdata[didx] + ":" 

end




groups=rawdata.to_a.map { |x| }


gidx=0

puts "#{groups}"

exit 

# Prep the hash
for i in 0.upto(rawdata.length+1) do
  groups[i]=[]
end


def group_vote_count(group)
  tally=0
  voters=group.length
  votes=group.map { |v| v.split(//) }

  common_votes=votes[0]

  votes.map { |v| common_votes &= v }

  puts "#{group.length} #{common_votes}"
  puts ""
end

for dline in rawdata do
  if dline != "" then
    groups[gidx].append(dline)
  else
    group_vote_count(groups[gidx])
    gidx += 1 
  end
end

gidx += 1 
groups[gidx].append(dline)

