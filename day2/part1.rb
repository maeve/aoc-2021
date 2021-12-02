#!/usr/bin/env ruby

horizontal = depth = 0

instructions = File.readlines('input.txt')

# Need to write some real tests
# instructions = [
#   'forward 5',
#   'down 5',
#   'forward 8',
#   'up 3',
#   'down 8',
#   'forward 2'
# ]
# Expected: horizontal * depth = 15 x 10 = 150

instructions.each do |instruction|
  case instruction
  when /forward (\d+)/
    horizontal += Regexp.last_match(1).to_i
  when /backward (\d+)/
    horizontal -= Regexp.last_match(1).to_i
  when /down (\d+)/
    depth += Regexp.last_match(1).to_i
  when /up (\d+)/
    depth -= Regexp.last_match(1).to_i
  end
end

puts "horizontal * depth = #{horizontal} * #{depth} = #{horizontal * depth}"
