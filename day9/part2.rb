#!/usr/bin/env ruby

require 'matrix'

class Basin
  attr_reader :heights, :basin_points

  def initialize(heights:, row:, col:)
    @basin_points = [[row, col]]
    @heights = heights
    draw_basin
  end

  def size
    basin_points.size
  end

  def include?(row, col)
    basin_points.include?([row, col])
  end

  private

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

  def process_point(row, col)
    basin_points << [row, col] if heights[row, col] != 9 && !basin_points.include?([row, col])
  end
end

input = File.readlines('input.txt')

heights = Matrix[*input.map { |line| line.chomp.split('').map(&:to_i) }]
basins = []

heights.each_with_index do |height, row, col|
  next if (row.positive? && heights[row - 1, col] <= height) ||
          (row + 1 < heights.row_count && heights[row + 1, col] <= height) ||
          (col.positive? && heights[row, col - 1] <= height) ||
          (col + 1 < heights.column_count && heights[row, col + 1] <= height)

  basin = Basin.new(heights: heights, row: row, col: col)
  basins << basin
end

top3 = basins.sort_by { |basin| -basin.size }.slice(0..2)

puts "Product: #{top3.map(&:size).reduce(:*)}"
