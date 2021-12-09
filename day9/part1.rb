#!/usr/bin/env ruby

require 'matrix'

input = File.readlines('input.txt')
# input = StringIO.new(<<-HERE
# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# HERE
# ).readlines

heights = Matrix[*input.map { |line| line.chomp.split('').map(&:to_i) }]

risk_level = 0

heights.each_with_index do |height, row, col|
  adjacent_heights = []

  adjacent_heights << heights[row - 1, col] unless row.zero?
  adjacent_heights << heights[row + 1, col] unless row + 1 == heights.row_count
  adjacent_heights << heights[row, col - 1] unless col.zero?
  adjacent_heights << heights[row, col + 1] unless col + 1 == heights.column_count

  risk_level += (1 + height) if adjacent_heights.min > height
end

puts "Risk level: #{risk_level}"
