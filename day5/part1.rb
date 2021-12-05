#!/usr/bin/env ruby

require 'matrix'
require 'pry'

# input = <<-HERE
# 0,9 -> 5,9
# 8,0 -> 0,8
# 9,4 -> 3,4
# 2,2 -> 2,1
# 7,0 -> 7,4
# 6,4 -> 2,0
# 0,9 -> 2,9
# 3,4 -> 1,4
# 0,0 -> 8,8
# 5,5 -> 8,2
# HERE
# input = input.split("\n")

input = File.readlines('input.txt')

class VentField
  attr_reader :grid

  def initialize(max_x: 999, max_y: 999)
    @grid = Matrix.build(max_y, max_x) { 0 }
  end

  # segment is a string of the form "x1,y1 -> x2,y2"
  def draw_segment(segment)
    coordinates = parse_segment(segment)
    return unless horizontal_or_vertical?(coordinates)

    # Coordinates can be in any order in the input, but it will
    # be more efficient for us if we're always drawing from min to max
    col_range = [coordinates[:start][0], coordinates[:end][0]].sort
    row_range = [coordinates[:start][1], coordinates[:end][1]].sort

    (row_range[0]..row_range[1]).each do |row|
      (col_range[0]..col_range[1]).each do |col|
        grid[row, col] += 1
      end
    end
  end

  def print_grid
    grid.row_vectors.each do |row|
      pretty_row = row.to_a.map { |elem| elem.zero? ? '.' : elem.to_s }.join
      puts pretty_row
    end
  end

  def overlap_count
    grid.select { |elem| elem > 1 }.size
  end

  private

  def parse_segment(segment)
    match = /(?<x1>[0-9]+),(?<y1>[0-9]+) -> (?<x2>[0-9]+),(?<y2>[0-9]+)/.match(segment)

    {
      start: [match['x1'].to_i, match['y1'].to_i],
      end: [match['x2'].to_i, match['y2'].to_i]
    }
  end

  def draw_line?(row:, col:, coordinates:)
    row.between?(*row_range) && col.between?(*col_range)
  end

  def horizontal_or_vertical?(coordinates)
    coordinates[:start][0] == coordinates[:end][0] ||
      coordinates[:start][1] == coordinates[:end][1]
  end
end

vent_field = VentField.new(max_x: 999, max_y: 999)

input.each do |segment|
  vent_field.draw_segment(segment.chomp)
end

vent_field.print_grid
puts
puts "Overlap count: #{vent_field.overlap_count}"
