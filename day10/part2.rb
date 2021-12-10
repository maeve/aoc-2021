#!/usr/bin/env ruby

input = File.readlines('input.txt')
# input = StringIO.new(<<-HERE
# [({(<(())[]>[[{[]{<()<>>
# [(()[<>])]({[<{<<[]>>(
# {([(<{}[<>[]}>{[]{[(<()>
# (((({<>}<{<{<>}{[]{[]{}
# [[<[([]))<([[{}[[()]]]
# [{[{({}]{}}([{[{{{}}([]
# {<[[]]>}<{[{[{[]{()[[[]
# [<(<(<(<{}))><([]([]()
# <{([([[(<>()){}]>(<<{{
# <{([{{}}[<[[[<>{}]]]>[]]
# HERE
# ).readlines

CHUNK_PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}.freeze

SCORES = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}.freeze

completions = []

input.each do |line|
  tokens = line.chomp.split('')
  chunks = []
  corrupted = false

  tokens.each do |token|
    if CHUNK_PAIRS.keys.include?(token)
      chunks.push(token)
    elsif (open_chunk = chunks.pop) != CHUNK_PAIRS.key(token)
      puts "#{line.chomp} - Expected #{CHUNK_PAIRS[open_chunk]}, but found #{token} instead."
      corrupted = true
      break
    end
  end

  next if corrupted

  completions << chunks.reverse.map { |c| CHUNK_PAIRS[c] }
  puts "#{line.chomp} - Complete by adding #{completions.last.join('')}."
end

puts

scores = completions.map do |completion|
  completion_score = completion.reduce(0) do |total, char|
    total * 5 + SCORES[char]
  end
  puts "#{completion.join('')} - #{completion_score} total points."
  completion_score
end.sort

puts

puts "Answer: #{scores[scores.length / 2]}"
