#!/usr/bin/env ruby

require 'matrix'
require 'set'

INFINITY = (2**(0.size * 8 -2) -1)

class Vertex
  attr_reader :row, :col, :risk
  attr_accessor :g_score, :f_score

  def initialize(row:, col:, risk:)
    @row = row
    @col = col
    @risk = risk

    self.g_score = row.zero? && col.zero? ? 0 : INFINITY
    self.f_score = row.zero? && col.zero? ? risk : INFINITY
  end

  def <=>(other_vertex)
    f_score <=> other_vertex.f_score
  end
end

class CaveMap
  attr_accessor :grid, :open_set, :came_from, :start, :finish

  def initialize(input:)
    initial_grid = Matrix[*input.map { |line| line.chomp.split('').map(&:to_i) }]

    grande_row = Matrix.hstack(*generate_partial_grids(initial_grid))
    self.grid = Matrix.vstack(*generate_partial_grids(grande_row))

    grid.each_with_index do |risk, row, col|
      grid[row, col] = Vertex.new(row: row, col: col, risk: risk)
    end

    self.start = grid[0, 0]
    self.finish = grid[grid.row_count - 1, grid.column_count - 1]

    self.open_set = SortedSet.new([start])
    self.came_from = {}
  end

  def compute_risk
    while (current = pop_next_vertex) && !finish?(current)
      open_set.delete(current)

      unvisited_neighbors(current).each do |neighbor|
        tentative_g_score = current.g_score + neighbor.risk
        next unless tentative_g_score < neighbor.g_score

        came_from[neighbor] = current
        neighbor.g_score = tentative_g_score
        neighbor.f_score = tentative_g_score + neighbor.risk

        open_set.add(neighbor)
      end
    end

    current.g_score
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
    vertex = open_set.first
    open_set.delete(vertex)
    vertex
  end

  def reconstruct_path(current)
    total_path = [current]

    while came_from.key?(current)
      current = came_from[current]
      total_path.prepend(current)
    end

    total_path
  end

  def finish?(vertex)
    vertex == finish
  end

  def unvisited_neighbors(vertex)
    neighbors = []
    row = vertex.row
    col = vertex.col

    neighbors << grid[row - 1, col] unless row.zero?
    neighbors << grid[row + 1, col] unless row + 1 == grid.row_count
    neighbors << grid[row, col - 1] unless col.zero?
    neighbors << grid[row, col + 1] unless col + 1 == grid.column_count

    neighbors
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
