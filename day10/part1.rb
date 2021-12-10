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

corruptions = []

input.each do |line|
  tokens = line.chomp.split('')
  chunks = []

  tokens.each do |token|
    if CHUNK_PAIRS.keys.include?(token)
      chunks.push(token)
    elsif (open_chunk = chunks.pop) != CHUNK_PAIRS.key(token)
      puts "#{line.chomp} - Expected #{CHUNK_PAIRS[open_chunk]}, but found #{token} instead."
      corruptions << token
      break
    end
  end
end

ERROR_SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}.freeze

score = corruptions.map { |c| ERROR_SCORES[c] }.sum

puts "Answer: #{score}"
