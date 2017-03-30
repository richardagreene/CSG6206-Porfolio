#!/usr/bin/env ruby
# Workshop 4 : edge detection

def binary?(value)
  # regular expression to check value
  # ref: http://stackoverflow.com/questions/14551256/ruby-how-to-find-out-if-a-character-is-a-letter-or-a-digit
  value =~ /[^0-1]/
end

input = gets.chomp
if not (input =~ /[^0-1]/).nil? then
    puts "Error: Only 0-1 values allowed. e.g. 0100001111"
    exit
end

prevChar = "0" 
result = ""
begin 
  input.split("").each do |currentChar|
    # XOR each char against the previous
    edge = (prevChar.to_i(2) ^ currentChar.to_i(2)).to_s(2)
    result = result+"#{edge}"
    prevChar = currentChar
  end
  puts "Input : #{input}"
  puts "Output: #{result}"
rescue Exception => e
  puts 'There was an unexpected error processing. ' + e.message
end    
