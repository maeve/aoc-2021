#!/usr/bin/env ruby

# input = ["16,1,2,0,4,2,7,1,2,14\n"]
input = File.readlines('input.txt')

input = input.first.chomp.split(',').map(&:to_i)

fuel_costs = Array.new(input.max)

(input.min..input.max).each do |position|
  fuel_costs[position] = input.reduce(0) do |sum, n|
    distance = n - position
    distance = -distance if distance.negative?

    cost = distance * (distance + 1) / 2
    sum + cost
  end
end

puts "Minimum cost #{fuel_costs.min} at position #{fuel_costs.index(fuel_costs.min)}"
