#!/usr/bin/env ruby

require 'matrix'
require 'rainbow'

class OctopusGrid
  attr_accessor :grid, :current_step, :flashes, :flash_count

  def initialize(input:)
    self.grid = Matrix[*input.map { |line| line.chomp.split('').map(&:to_i) }]
    self.current_step = 0
    self.flash_count = 0
    self.flashes = []

    print_grid
  end

  def print_grid
    puts current_step.zero? ? 'Before any steps:' : "After step #{current_step}:"

    grid.row_vectors.each do |row|
      puts row.to_a.map { |energy| energy.zero? ? Rainbow(energy.to_s).bright.white : energy.to_s }.join('')
    end

    puts
  end

  def step
    self.current_step += 1
    self.flashes = []

    self.grid += Matrix.build(grid.row_count, grid.column_count) { 1 }
    flashed = 0

    loop { break if flash_all.zero? }

    flashes.each { |row, col| grid[row, col] = 0 }

    self.flash_count += flashes.size

    print_grid
  end

  private

  def flash_all
    flashed = 0

    grid.each_with_index do |energy, row, col|
      if energy > 9 && !flashed?(row, col)
        flash(row, col)
        flashed += 1
      end
    end

    flashed
  end

  def flashed?(row, col)
    flashes.include?([row, col])
  end

  def flash(row, col)
    flashes << [row, col]

    grid[row - 1, col] += 1 unless row.zero?
    grid[row - 1, col - 1] += 1 unless row.zero? || col.zero?
    grid[row - 1, col + 1] += 1 if row.positive? && col + 1 < grid.column_count

    grid[row, col - 1] += 1 unless col.zero?
    grid[row, col + 1] += 1 if col + 1 < grid.column_count

    grid[row + 1, col] += 1 if row + 1 < grid.row_count
    grid[row + 1, col - 1] += 1 if col.positive? && row + 1 < grid.row_count
    grid[row + 1, col + 1] += 1 if col + 1 < grid.column_count && row + 1 < grid.row_count
  end
end

input = File.readlines('input.txt')
# input = StringIO.new(<<-HERE
# 5483143223
# 2745854711
# 5264556173
# 6141336146
# 6357385478
# 4167524645
# 2176841721
# 6882881134
# 4846848554
# 5283751526
# HERE
# ).readlines

model = OctopusGrid.new(input: input)

model.step until model.grid.sum == 0

puts "Answer: #{model.current_step}"
