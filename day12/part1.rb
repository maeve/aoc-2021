#!/usr/bin/env ruby

require 'set'

class Cave
  attr_reader :name, :passages
  attr_accessor :visited

  def initialize(name:)
    @name = name
    @passages ||= Set.new
    self.visited = false
  end

  def small?
    name =~ /^[a-z]+$/
  end

  def add_passage(cave)
    passages << cave
  end

  def visited?
    small? && visited
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

      start.visited = true

      current_path.push(start)

      if start == finish
        paths << current_path
      else
        start.passages.each do |cave|
          find_paths(start: cave, finish: finish)
        end
      end

      current_path.pop
      start.visited = false

      paths
    end

    private

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

puts "Answer : #{paths.size} paths"
