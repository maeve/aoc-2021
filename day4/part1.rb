#!/usr/bin/env ruby

require 'matrix'

input = File.readlines('input.txt')

drawn_numbers = input[0].split(',').map(&:to_i)

cards = []

input[1..].each_slice(6) do |card_input|
  cards << Matrix[*card_input[1..].map { |row| row.chomp.split(' ').map(&:to_i) }]
end

called_numbers = drawn_numbers.slice!(0..3)
winner = nil
inverse_markers = nil

until winner
  called_numbers << drawn_numbers.shift
  inverse_marked_cards = cards.map { |card| card.map { |square| called_numbers.include?(square) ? 0 : 1 } }
  match_index = inverse_marked_cards.find_index do |card|
    card.row_vectors.any? { |row| row.sum.zero? } ||
      card.column_vectors.any? { |col| col.sum.zero? }
  end

  if match_index
    winner = cards[match_index]
    inverse_markers = inverse_marked_cards[match_index]
  end
end

puts 'Winning card'
winner.row_vectors.each { |row| puts row.inspect }

unmarked_sum = 0

winner.each_with_index do |elem, row, col|
  unmarked_sum += elem.to_i * inverse_markers[row, col]
end

puts "Unmarked sum: #{unmarked_sum}"
puts "Last number called: #{called_numbers.last}"
puts "Answer: #{unmarked_sum * called_numbers.last}"
