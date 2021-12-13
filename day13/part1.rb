#!/usr/bin/env ruby

require 'matrix'

class TransparentPaper
  attr_accessor :grid, :folds

  def initialize(rows:, columns:, dots:, folds:)
    self.grid = Matrix.build(rows, columns) { 0 }
    self.folds = folds

    dots.each { |dot| grid[*dot] = 1 }
  end

  def print
    grid.row_vectors.each do |row|
      puts row.to_a.map { |val| val.zero? ? '.' : '#' }.join('')
    end
  end

  def dot_count
    grid.sum
  end

  def fold
    instruction = folds.first

    if instruction.key?(:row)
      fold_up_along(instruction[:row])
    elsif instruction.key?(:column)
      fold_left_along(instruction[:column])
    end
  end

  private

  def fold_up_along(row)
    top = Matrix.rows(grid.row_vectors.slice(0..(row - 1)))
    bottom = Matrix.rows(grid.row_vectors.slice((row + 1)..-1))
    flipped = Matrix.columns(bottom.column_vectors.map { |col| col.to_a.reverse })

    self.grid = top.combine(flipped) { |a, b| a | b }
  end

  def fold_left_along(column)
    left = Matrix.columns(grid.column_vectors.slice(0..(column - 1)))
    right = Matrix.columns(grid.column_vectors.slice((column + 1)..-1))
    flipped = Matrix.rows(right.row_vectors.map { |row| row.to_a.reverse })

    self.grid = left.combine(flipped) { |a, b| a | b }
  end

  class << self
    def setup_paper(input)
      dots, folds = parse_input(input)

      rows = dots.map(&:first).max + 1
      columns = dots.map(&:last).max + 1

      TransparentPaper.new(
        rows: rows,
        columns: columns,
        dots: dots,
        folds: folds
      )
    end

    def parse_input(input)
      separator = input.find_index { |line| line.strip.empty? }
      dots = input.slice(0..(separator - 1)).map { |line| line.chomp.split(',').map(&:to_i).reverse }
      folds = input.slice((separator + 1)..-1).map do |line|
        axis, index = line.match(/^fold along ([xy])=([0-9]+)$/).captures

        axis == 'y' ? { row: index.to_i } : { column: index.to_i }
      end

      [dots, folds]
    end
  end
end

input = File.readlines('input.txt')

# input = StringIO.new(<<-HERE
# 6,10
# 0,14
# 9,10
# 0,3
# 10,4
# 4,11
# 6,0
# 6,12
# 4,1
# 0,13
# 10,12
# 3,4
# 3,0
# 8,4
# 1,10
# 2,14
# 8,10
# 9,0

# fold along y=7
# fold along x=5
# HERE
# ).readlines

paper = TransparentPaper.setup_paper(input)
paper.print
paper.fold

puts
puts "After folding:"
puts

paper.print

puts
puts "Answer: #{paper.dot_count}"
