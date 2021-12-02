#!/usr/bin/env ruby

lines = File.readlines('input.txt').map(&:to_i)
sums = (2..lines.size - 1).map { |i| lines.slice(i - 2..i).sum }
diffs = sums.map.with_index { |sum, i| (sum - sums[i - 1]) unless i.zero? }
diffs.shift
answer = diffs.partition(&:positive?).first.size

puts "Answer: #{answer}"
