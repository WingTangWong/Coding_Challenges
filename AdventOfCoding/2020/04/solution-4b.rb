#!/usr/bin/env ruby
#
#
# Validate number of fields
# * changed working records into array of hashes.
DEBUG   = false
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

if DEBUG then
  puts records.length
  puts records
  puts new_records.length
  puts new_records
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


def valid_pid( record )
  valid = true
  if record.length == 9 then
  end
  return valid
end

def valid_cid( record )
  return true
end



def are_all_fields_present( record, fields )
  valid = true
  for f in fields do
    r_check=0
    for r in record do
      if r.start_with?(f) then
        r_check += 1
      end
    end
    valid = valid && ( r_check == 1 )
  end
  return valid
end


def is_record_valid( record )
  valid = true
  valid = valid && are_all_fields_present( record, REQUIRED_FIELDS )
  return valid
end


total_records = 0
valid_records = 0

for record in records do
  total_records += 1
  if is_record_valid( record ) then
    valid_records += 1
  end
  puts valid_pid(record)
end

puts "Total records: #{total_records} , Valid records: #{valid_records}"











