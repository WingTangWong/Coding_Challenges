#!/usr/bin/env ruby
#
#
# Validate number of fields
#
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
  new_records.append( rec.split(/ /) )
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
end

puts "Total records: #{total_records} , Valid records: #{valid_records}"











