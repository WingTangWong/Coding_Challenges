#!/usr/bin/env ruby
#
#
# Validate number of fields
# * changed working records into array of hashes.
DEBUG   = true
SRC     = ARGV[0]
fh      = File.open(SRC)
raw_data = fh.readlines.map { | datum | datum.chomp }

record_idx = 0
current_record = ""
records = []

# Organize data into clear records. Get rid of line breaks/etc.
for idx in 0..(raw_data.count) do
  if raw_data[idx] == nil then
    records.append(current_record.clone)
    break
  end
  if raw_data[idx].length == 0 then
    records.append(current_record.clone)
    current_record=""
    record_idx += 1
  else
    current_record += raw_data[idx].to_s + " "
  end
end

new_records = []
for rec in records do
  new_entry = {}
  for r in rec.split(/ /) do
    key,value = r.split(/:/)
    new_entry[key] = value
  end
  new_records.append( new_entry )
end

records = new_records.clone

# Fields
#  byr (Birth Year)
#  iyr (Issue Year)
#  eyr (Expiration Year)
#  hgt (Height)
#  hcl (Hair Color)
#  ecl (Eye Color)
#  pid (Passport ID)
#  cid (Country ID)

ALL_FIELDS      = [ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid", "cid" ]
REQUIRED_FIELDS = [ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" ]

#  byr (Birth Year) - four digits; at least 1920 and at most 2002.
#  iyr (Issue Year) - four digits; at least 2010 and at most 2020.
#  eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
#  hgt (Height) - a number followed by either cm or in:
#  If cm, the number must be at least 150 and at most 193.
#  If in, the number must be at least 59 and at most 76.
#  hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
#  ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
#  pid (Passport ID) - a nine-digit number, including leading zeroes.
#  cid (Country ID) - ignored, missing or not.
def is_byr_valid?( record )
  valid = true
  return valid
end

def is_iyr_valid?( record )
  valid = true
  return valid
end

def is_eyr_valid?( record )
  valid = true
  return valid
end

def is_hgt_valid?( record )
  valid = true
  return valid
end

def is_hcl_valid?( record )
  valid = true
  return valid
end

def is_ecl_valid?( record )
  valid = true
  return valid
end

def is_pid_valid?( record )
  valid = true
  if record["pid"].length != 9 then
    valid = false
  end
  if DEBUG then
    puts "[PID]>> #{valid}"
  end
  return valid
end

def is_cid_valid?( record )
  if DEBUG then
    puts "[CID]>> always true"
  end
  return true
end



def is_field_count_valid?( record, fields )
  valid = true
  if DEBUG then
    puts "[field count]>> field count : required : ##{fields.count}"
  end
  
  found_fields = record.keys.map { | ff | ff.to_s }
  
  if DEBUG then
    puts "[field count]>> found fields: : ##{found_fields}"
  end

  for f in fields do
    if !found_fields.member?(f) then
      valid = false
      if DEBUG then
        puts "[field count]>> did not find field : #{f}"
      end
    end
  end

  if DEBUG then
    puts "[field count]>> field_count valid : #{valid}"
  end
  return valid
end


def is_record_valid?( record )
  valid = true
  if DEBUG then
    puts ">> is_record_valid : start : ##{valid}"
  end
  # check for field count
  if !is_field_count_valid?( record, REQUIRED_FIELDS ) then
    valid = false
  end
  # validate pid
  if !is_pid_valid?(record) then
    valid = false
  end
  # validate cid
  if !is_cid_valid?(record) then
    valid = false
  end
  # validate byr
  if !is_byr_valid?(record) then
    valid = false
  end
  # validate iyr
  if !is_iyr_valid?(record) then
    valid = false
  end
  # validate eyr
  if !is_eyr_valid?(record) then
    valid = false
  end
  # validate hgt
  if !is_hgt_valid?(record) then
    valid = false
  end
  return valid
end


total_records = 0
valid_records = 0

for record in records do
  if DEBUG then
    puts ">> Record ##{valid_records}"
  end
  if is_record_valid?( record ) then
    valid_records += 1
  end
  if DEBUG then
    puts ">> Valid Records: #{valid_records}"
  end
  total_records += 1
end

puts "Total records: #{total_records} , Valid records: #{valid_records}"
