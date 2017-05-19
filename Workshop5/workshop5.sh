#!/usr/bin/env ruby
# Workshop 5 : edge detection
# Usage: 
#     cat <filename> | ./workshop5.sh

def CalculateEdge(arr)
  result = ""   
  # loop over each line of the array of text items
  for lineIndex in 0 ... arr.size
     topChar = "0" # start empty
     prevChar = "0" # start empty 
     for charIndex in 0 ... arr[lineIndex].chomp.size
       # consider <whitespace> as '0'
       currentChar = arr[lineIndex][charIndex].gsub(/\s/,'0')
       # validation checks 
        if lineIndex == 0 then
          topChar = currentChar  # assume current char if first row
        elsif lineIndex > 0 && charIndex > arr[lineIndex-1].chomp.size
          topChar = "0"  # assume "0" if missing on row above
        else
          topChar = arr[lineIndex-1][charIndex].nil? ? "0" : arr[lineIndex-1][charIndex].gsub(/\s/,'0')
        end
        # XOR char against the previous char to the left of current
        edgeLeft = prevChar.to_i(2) ^ currentChar.to_i(2)
        # XOR char against the char above the current
        edgeTop = currentChar.to_i(2) ^ topChar.to_i(2)
        # if the left char has not changed use the top row
        edge = edgeLeft == 1 ? edgeLeft : edgeTop
        prevChar = currentChar
        result = result+"#{edge}"
     end
   result = "#{result}\n"
   end
   return result
end

# Place each line into an array
begin
  input = $stdin.read
  if not (input =~ /[^0-1\W]/).nil? then
      puts "Error: Only 0-1 values allowed. e.g. 0100001111"
      puts "       Whitespace will be considered '0'"
      exit
  end
  arr = input.split(/\n/)
  result = CalculateEdge(arr)
# puts "Input :\t#{input}"
  puts "#{result}"
rescue Exception => e
  puts 'There was an unexpected error processing. ' + e.message
end
