#!/usr/bin/env ruby

require 'matrix'
require 'set'

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

  def <=>(other_vertex)
    distance <=> other_vertex.distance
  end
end

class CaveMap
  attr_accessor :grid, :unvisited_set

  def initialize(input:)
    initial_grid = Matrix[*input.map { |line| line.chomp.split('').map(&:to_i) }]

    grande_row = Matrix.hstack(*generate_partial_grids(initial_grid))
    self.grid = Matrix.vstack(*generate_partial_grids(grande_row))

    self.unvisited_set = SortedSet.new

    grid.each_with_index do |risk, row, col|
      grid[row, col] = Vertex.new(row: row, col: col, risk: risk)
      unvisited_set << grid[row, col]
    end
  end

  def compute_risk
    while (current = pop_next_vertex) && !finish?(current)
      unvisited_neighbors(current).each do |neighbor|
        new_distance = current.distance + neighbor.risk
        neighbor.distance = new_distance if new_distance < neighbor.distance
      end
      current.visit
    end

    grid[grid.row_count - 1, grid.column_count - 1].distance
  end

  private

  def generate_partial_grids(initial)
    all_grids = [initial]

    (1..4).to_a.each do |position|
      adjustment = Matrix.build(initial.row_count, initial.column_count) { position }

      all_grids << initial.combine(adjustment) do |original, weight|
        total = original + weight
        total > 9 ? total % 9 : total
      end
    end

    all_grids
  end

  def pop_next_vertex
    vertex = unvisited_set.first
    unvisited_set.delete(vertex)
    vertex
  end

  def finish?(vertex)
    vertex.row == grid.row_count - 1 &&
      vertex.col == grid.column_count - 1
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
