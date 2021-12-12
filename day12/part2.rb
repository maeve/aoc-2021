#!/usr/bin/env ruby

require 'set'

class Cave
  attr_reader :name, :passages
  attr_accessor :visit_count

  def initialize(name:)
    @name = name
    @passages ||= Set.new
    self.visit_count = 0
  end

  def small?
    name =~ /^[a-z]+$/
  end

  def add_passage(cave)
    passages << cave
  end

  def visit
    self.visit_count += 1
  end

  def unvisit
    self.visit_count -= 1
  end

  def visited?
    return false if !small? || visit_count.zero?

    double_visit = self.class.current_path.detect { |cave| cave.small? && cave.visit_count == 2 }
    return false if double_visit.nil? && !['start', 'end'].include?(name)

    true
  end

  class << self
    def caves
      @caves ||= {}
    end

    def [](name)
      caves[name] ||= Cave.new(name: name)
    end

    def map_passages(input)
      input.each do |line|
        passage = line.chomp.split('-')
        Cave[passage.first].add_passage(Cave[passage.last])
        Cave[passage.last].add_passage(Cave[passage.first])
      end
    end

    # Basically a depth first search
    def find_paths(start:, finish:)
      return if start.visited?

      start.visit

      current_path.push(start)

      if start == finish
        paths << current_path.clone
      else
        start.passages.each do |cave|
          find_paths(start: cave, finish: finish)
        end
      end

      current_path.pop
      start.unvisit

      paths
    end

    def paths
      @paths ||= []
    end

    def current_path
      @current_path ||= []
    end
  end
end

input = File.readlines('input.txt')

# input = StringIO.new(<<-HERE
# start-A
# start-b
# A-c
# A-b
# b-d
# A-end
# b-end
# HERE
# ).readlines

# input = StringIO.new(<<-HERE
# dc-end
# HN-start
# start-kj
# dc-start
# dc-HN
# LN-dc
# HN-end
# kj-sa
# kj-HN
# kj-dc
# HERE
# ).readlines

# input = StringIO.new(<<-HERE
# fs-end
# he-DX
# fs-he
# start-DX
# pj-DX
# end-zg
# zg-sl
# zg-pj
# pj-he
# RW-he
# fs-DX
# pj-RW
# zg-RW
# start-pj
# he-WI
# zg-he
# pj-fs
# start-RW
# HERE
# ).readlines

Cave.map_passages(input)
paths = Cave.find_paths(start: Cave['start'], finish: Cave['end'])

# paths.each do |path|
#   puts path.map(&:name).join(',')
# end

puts
puts "Answer : #{paths.size} paths"
