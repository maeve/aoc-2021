#!/usr/bin/env ruby

require 'matrix'
require 'pry-byebug'

class Basin
  attr_reader :heights, :basin_points

  def initialize(heights:, row:, col:)
    @basin_points = [[row, col]]
    @heights = heights
  end

  def draw_basin
    index = 0

    while index < basin_points.size
      row, col = basin_points[index]

      process_point(row - 1, col) unless row.zero?
      process_point(row + 1, col) if row + 1 < heights.row_count
      process_point(row, col - 1) unless col.zero?
      process_point(row, col + 1) if col + 1 < heights.column_count

      index += 1
    end
  end

  def print_map
    basin_map = heights.clone

    basin_map.each_with_index do |_, row, col|
      basin_map[row, col] = '.' unless basin_points.include?([row, col])
    end

    basin_map.row_vectors.each do |row_vector|
      puts row_vector.to_a.join('')
    end
  end

  def size
    basin_points.size
  end

  private

  def process_point(row, col)
    basin_points << [row, col] if heights[row, col] != 9 && !basin_points.include?([row, col])
  end
end

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

basins = []

heights.each_with_index do |height, row, col|
  adjacent_heights = []

  adjacent_heights << heights[row - 1, col] unless row.zero?
  adjacent_heights << heights[row + 1, col] unless row + 1 == heights.row_count
  adjacent_heights << heights[row, col - 1] unless col.zero?
  adjacent_heights << heights[row, col + 1] unless col + 1 == heights.column_count

  if adjacent_heights.min > height
    basin = Basin.new(heights: heights, row: row, col: col)
    basins << basin
    basin.draw_basin
  end
end

basins.sort_by! { |basin| -basin.size }

top3 = basins.slice(0..2)

top3.each do |basin|
  basin.print_map
  puts "Size: #{basin.size}"
  puts
end

puts "Product: #{top3.map(&:size).reduce(:*)}"
