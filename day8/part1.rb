#!/usr/bin/env ruby

input = File.readlines('input.txt')
# input = StringIO.new(<<-HERE
# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
# edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
# fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
# fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
# aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
# fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
# dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
# bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
# egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
# gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
# HERE
#                     ).readlines

count = Array.new(10) { 0 }

input.each do |line|
  signals, outputs = line.chomp.split(' | ').map { |s| s.split(' ') }

  count[1] += outputs.select { |signal| signal.size == 2 }.size
  count[4] += outputs.select { |signal| signal.size == 4 }.size
  count[7] += outputs.select { |signal| signal.size == 3 }.size
  count[8] += outputs.select { |signal| signal.size == 7 }.size
end

puts "Instances of 1, 4, 7, or 8: #{count[1] + count[4] + count[7] + count[8]}"
