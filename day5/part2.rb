#!/usr/bin/env ruby

require 'matrix'

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

class VentMap
  attr_reader :grid

  def initialize(max_x: 999, max_y: 999)
    @grid = Matrix.build(max_y, max_x) { 0 }
  end

  # segment is a string of the form "x1,y1 -> x2,y2"
  def draw_segment(segment)
    coordinates = parse_segment(segment)

    x_delta = coordinates[:end][0] - coordinates[:start][0]
    y_delta = coordinates[:end][1] - coordinates[:start][1]

    current_point = coordinates[:start]

    loop do
      grid[*current_point.reverse] += 1

      break if current_point == coordinates[:end]

      current_point[0] = increment_coordinate_value(current_point[0], x_delta)
      current_point[1] = increment_coordinate_value(current_point[1], y_delta)
    end
  end

  def increment_coordinate_value(value, delta)
    if delta.positive?
      value + 1
    elsif delta.negative?
      value - 1
    else
      value
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
end

vent_map = VentMap.new(max_x: 999, max_y: 999)

input.each do |segment|
  vent_map.draw_segment(segment.chomp)
end

vent_map.print_grid
puts
puts "Overlap count: #{vent_map.overlap_count}"
