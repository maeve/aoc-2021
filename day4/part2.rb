#!/usr/bin/env ruby

require 'matrix'

require 'pry'
input = File.readlines('input.txt')

drawn_numbers = input[0].split(',').map(&:to_i)

cards = []

input[1..].each_slice(6) do |card_input|
  cards << Matrix[*card_input[1..].map { |row| row.chomp.split(' ').map(&:to_i) }]
end

called_numbers = drawn_numbers.slice!(0..3)
winner = nil
inverse_markers = nil
winning_number = nil

until drawn_numbers.empty?
  called_numbers << drawn_numbers.shift
  inverse_marked_cards = cards.map { |card| card.map { |square| called_numbers.include?(square) ? 0 : 1 } }
  matches = inverse_marked_cards.each_index.select do |index|
    card = inverse_marked_cards[index]
    card.row_vectors.any? { |row| row.sum.zero? } ||
      card.column_vectors.any? { |col| col.sum.zero? }
  end

  until matches.empty?
    match_index = matches.pop
    winner = cards.delete_at(match_index)
    inverse_markers = inverse_marked_cards[match_index]
    winning_number = called_numbers.last
  end
end

puts 'Winning card'
winner.row_vectors.each { |row| puts row }

puts 'Inverse markers'
inverse_markers.row_vectors.each { |row| puts row }

unmarked_sum = 0

winner.each_with_index do |elem, row, col|
  unmarked_sum += elem.to_i * inverse_markers[row, col]
end

puts "Unmarked sum: #{unmarked_sum}"
puts "Last number called: #{winning_number}"
puts "Answer: #{unmarked_sum * winning_number}"
