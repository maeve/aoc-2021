#!/usr/bin/env ruby

horizontal = depth = aim = 0

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
# Expected: horizontal * depth = 15 x 60 = 900

instructions.each do |instruction|
  case instruction
  when /forward (\d+)/
    x = Regexp.last_match(1).to_i
    horizontal += x
    depth += (aim * x)
  when /down (\d+)/
    x = Regexp.last_match(1).to_i
    aim += x
  when /up (\d+)/
    x = Regexp.last_match(1).to_i
    aim -= x
  end
end

puts "horizontal * depth = #{horizontal} * #{depth} = #{horizontal * depth}"
`echo #{horizontal * depth} | pbcopy`
