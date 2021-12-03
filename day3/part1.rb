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
# Gamma: 22
# Epsilon: 9
# Power consumption: 198

bit_matrix = Matrix[*input.map { |str| str.chomp.split('') }]

gamma_bits = bit_matrix.column_vectors.map do |col|
  partitioned_bits = col.partition { |v| v.to_i.zero? }
  partitioned_bits.first.size > partitioned_bits.last.size ? '0' : '1'
end

gamma = gamma_bits.join('').to_i(2)
epsilon = gamma ^ ((1 << gamma.bit_length) - 1)

puts "Gamma: #{gamma}"
puts "Epsilon: #{epsilon}"
puts "Power consumption: #{gamma * epsilon}"
