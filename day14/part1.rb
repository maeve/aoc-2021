#!/usr/bin/env ruby

require 'matrix'

class Polymer
  attr_accessor :template, :rules

  def initialize(template:, rules:)
    self.template = template
    self.rules = rules
  end

  def process(step_count:)
    (1..step_count).each do |step|
      expanded_template = []

      template.each_cons(2) do |pair|
        expanded_template << pair.first
        expanded_template << rules[pair] if rules[pair]
      end

      expanded_template << template.last

      self.template = expanded_template
    end
  end

  def distribution
    template.group_by { |i| i }.map { |key, values| [key, values.size] }.sort_by { |key, count| count }.reverse
  end

  def answer
    distribution.first[1] - distribution.last[1]
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
polymer.process(step_count: 10)

polymer.distribution.each do |letter, count|
  puts "(#{letter}, #{count})"
end

puts "Answer: #{polymer.answer}"

