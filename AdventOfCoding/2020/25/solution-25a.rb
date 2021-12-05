#!/usr/bin/env ruby

SRC     = ARGV[0]
fh      = File.open(SRC)
rawdata = fh.readlines.map { | datum | datum.chomp }


