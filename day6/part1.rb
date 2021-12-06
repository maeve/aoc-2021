#!/usr/bin/env ruby

# input = '3,4,3,1,2'
input = File.readlines('input.txt')

fish_ages = input.first.chomp.split(',').map(&:to_i)

puts "Initial state: #{fish_ages.map(&:to_s).join(',')}"

(1..80).each do |day|
  new_fish = []

  fish_ages.each_with_index do |age, i|
    if age.zero?
      new_fish << 8
      fish_ages[i] = 6
    else
      fish_ages[i] -= 1
    end
  end

  fish_ages += new_fish

  puts "After #{day.to_s.rjust(2)} days: #{fish_ages.join(',')}"
end

puts
puts "Number of fish: #{fish_ages.size}"
