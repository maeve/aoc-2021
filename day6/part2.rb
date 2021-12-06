#!/usr/bin/env ruby

# input = ['3,4,3,1,2']
input = File.readlines('input.txt')

input = input.first.chomp.split(',').map(&:to_i)

fish_ages = Array.new(9) { 0 }
input.each { |age| fish_ages[age] += 1 }

(1..256).each do |day|
  new_fish = fish_ages[0]

  (0..7).each do |i|
    fish_ages[i] = fish_ages[i + 1]
  end

  fish_ages[6] += new_fish
  fish_ages[8] = new_fish
end

puts "Number of fish: #{fish_ages.sum}"
