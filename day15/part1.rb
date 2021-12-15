#!/usr/bin/env ruby

require 'matrix'

INFINITY = (2**(0.size * 8 -2) -1)

class Vertex
  attr_reader :row, :col, :risk
  attr_accessor :distance

  def initialize(row:, col:, risk:)
    @row = row
    @col = col
    @risk = risk

    self.distance = row.zero? && col.zero? ? 0 : INFINITY

    unvisit
  end

  def unvisited?
    !@visited
  end

  def unvisit
    @visited = false
  end

  def visit
    @visited = true
  end
end

class CaveMap
  attr_accessor :grid, :unvisited_set

  def initialize(input:)
    self.grid = Matrix[*input.map { |line| line.chomp.split('').map(&:to_i) }]

    self.unvisited_set = []

    grid.each_with_index do |risk, row, col|
      grid[row, col] = Vertex.new(row: row, col: col, risk: risk)
      unvisited_set << grid[row, col]
    end
  end

  def compute_risk
    while (current = pop_next_vertex)
      unvisited_neighbors(current).each do |neighbor|
        new_distance = current.distance + neighbor.risk
        neighbor.distance = new_distance if new_distance < neighbor.distance
      end
      current.visit
    end

    grid[grid.row_count - 1, grid.column_count - 1].distance
  end

  private

  def pop_next_vertex
    unvisited_set.sort_by! { |v| -v.distance }
    unvisited_set.pop
  end

  def unvisited_neighbors(vertex)
    neighbors = []
    row = vertex.row
    col = vertex.col

    neighbors << grid[row - 1, col] unless row.zero?
    neighbors << grid[row + 1, col] unless row + 1 == grid.row_count
    neighbors << grid[row, col - 1] unless col.zero?
    neighbors << grid[row, col + 1] unless col + 1 == grid.column_count

    neighbors.select(&:unvisited?)
  end

end

input = File.readlines('input.txt')

# input = StringIO.new(<<-HERE
# 1163751742
# 1381373672
# 2136511328
# 3694931569
# 7463417111
# 1319128137
# 1359912421
# 3125421639
# 1293138521
# 2311944581
# HERE
# ).readlines

map = CaveMap.new(input: input)

puts "Answer: #{map.compute_risk}"
