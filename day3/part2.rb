#!/usr/bin/env ruby

require 'matrix'

input = File.readlines('input.txt')

# input = %w[
#   00100
#   11110
#   10110
#   10111
#   10101
#   01111
#   00111
#   11100
#   10000
#   11001
#   00010
#   01010
# ]
# Expected:
# O2: 23
# CO2: 10
# Life Support: 230

def compute_criteria(numbers)
  bit_matrix = Matrix[*numbers.map { |n| n.split('') }]

  partitioned_bits = bit_matrix.column_vectors.map do |col|
    col.partition { |v| v.to_i.zero? }
  end

  filtered_bits = partitioned_bits.map do |col|
    col[0].size > col[1].size ? '0' : '1'
  end
  filtered_bits.join('').to_i(2)
end

O2_CRITERIA = 1
CO2_CRITERIA = 0

def find_rating_by_criteria(input, criteria)
  bin_numbers = input.map { |v| v.chomp }
  bit_position = 0

  while bin_numbers.size > 1
    criteria_val = compute_criteria(bin_numbers)

    if criteria == CO2_CRITERIA
      criteria_val = criteria_val ^ ((1 << bin_numbers[0].length) - 1)
    end

    criteria_val = '%0*b' % [bin_numbers[0].length, criteria_val]
    bin_numbers = bin_numbers.select { |n| n[bit_position] == criteria_val[bit_position] }
    bit_position += 1
  end

  bin_numbers.first.to_i(2)
end

o2_rating = find_rating_by_criteria(input, O2_CRITERIA)
puts "O2: #{o2_rating}"

co2_rating = find_rating_by_criteria(input, CO2_CRITERIA)
puts "CO2: #{co2_rating}"

puts "Life support rating: #{o2_rating * co2_rating}"
