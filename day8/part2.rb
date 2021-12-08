#!/usr/bin/env ruby

input = File.readlines('input.txt')

output_values = input.map do |line|
  patterns, outputs = line.chomp.split(' | ').map { |signals| signals.split(' ').map { |signal| signal.split('').sort } }

  mapped_digits = Array.new(10)
  mapped_digits[1] = patterns.detect { |signal| signal.size == 2 }
  mapped_digits[4] = patterns.detect { |signal| signal.size == 4 }
  mapped_digits[7] = patterns.detect { |signal| signal.size == 3 }
  mapped_digits[8] = patterns.detect { |signal| signal.size == 7 }

  mapped_digits[6] = patterns.detect { |signal| signal.size == 6 && (signal & mapped_digits[1]) != mapped_digits[1] }
  mapped_digits[9] = patterns.detect { |signal| signal.size == 6 && (signal & mapped_digits[4]) == mapped_digits[4] }
  mapped_digits[0] = patterns.detect { |signal| signal.size == 6 && signal != mapped_digits[6] && signal != mapped_digits[9] }

  mapped_digits[3] = patterns.detect { |signal| signal.size == 5 && (signal & mapped_digits[1]) == mapped_digits[1] }
  mapped_digits[5] = patterns.detect { |signal| signal.size == 5 && (signal & mapped_digits[6]) == signal }
  mapped_digits[2] = patterns.detect { |signal| signal.size == 5 && signal != mapped_digits[3] && signal != mapped_digits[5] }

  outputs.map { |segments| mapped_digits.index(segments).to_s }.join.to_i
end

puts "Sum: #{output_values.sum}"
