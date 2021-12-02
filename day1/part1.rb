#!/usr/bin/env ruby

lines = File.readlines('input.txt')
diffs = lines.map.with_index { |line, i| (line.to_i - lines[i - 1].to_i) unless i.zero? }
diffs.shift
puts diffs.partition(&:positive?).first.size
