#!/usr/bin/env ruby

require 'matrix'

class Polymer
  attr_accessor :template, :rules, :letter_counts, :pair_counts

  def initialize(template:, rules:)
    self.template = template
    self.rules = rules

    self.letter_counts = template.group_by { |i| i }.map { |key, values| [key, values.size] }.to_h
    self.letter_counts.default = 0
    self.pair_counts = Hash.new { 0 }
    template.each_cons(2) { |pair| pair_counts[pair] += 1 }
  end

  def process(step_count:)
    step_count.times do
      new_pair_counts = Hash.new { 0 }

      pair_counts.each do |pair, count|
        if (insertion = rules[pair])
          new_pair_counts[[pair.first, insertion]] += count
          new_pair_counts[[insertion, pair.last]] += count
          letter_counts[insertion] += count
        else
          new_pair_counts[pair] = count
        end
      end

      self.pair_counts = new_pair_counts
    end
  end

  def answer
    sorted_counts = self.letter_counts.values.sort.reverse
    sorted_counts.first - sorted_counts.last
  end

  class << self
    def setup_polymer(input)
      template = input.first.chomp.split('')
      rules = input.slice(2..-1).map do |line|
        pair_first, pair_last, insertion = line.match(/([A-Z])([A-Z]) -> ([A-Z])/).captures

        [[pair_first, pair_last], insertion]
      end.to_h

      Polymer.new(template: template, rules: rules)
    end
  end
end

input = File.readlines('input.txt')

# input = StringIO.new(<<-HERE
# NNCB

# CH -> B
# HH -> N
# CB -> H
# NH -> C
# HB -> C
# HC -> B
# HN -> C
# NN -> C
# BH -> H
# NC -> B
# NB -> B
# BN -> B
# BB -> N
# BC -> B
# CC -> N
# CN -> C
# HERE
# ).readlines

polymer = Polymer.setup_polymer(input)

polymer.process(step_count: 40)

puts "Answer: #{polymer.answer}"
