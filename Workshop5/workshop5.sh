#!/usr/bin/env ruby
# Workshop 4 : edge detection
# Usage: cat input.txt
#     000011101110011111 
#     000010101110011111 
#     000011101110011011 
#     000010101110011111 
# cat input.txt | ./workshop4.sh

def GetMaxRowLength(arr)
  maxRowLength = 0
  arr.each { |line| 
    if line.length > maxRowLength then
      maxRowLength = line.length
    end
  }
  return maxRowLength
end

def CalculateEdge(arr)
  topChar = "0" 
  result = ""
  # loop over each line of the array
  for lineIndex in 0 ... arr.size
     prevChar = "0" 
     for charIndex in 0 ... arr[lineIndex].size
       currentChar = arr[lineIndex][charIndex]
        if lineIndex == 0 then 
          topChar = currentChar  # assume current char if first row
        elsif lineIndex > 0 && charIndex > arr[lineIndex-1].size
          topChar = "0"  # assume "0" if missing on row above
        else
          topChar = arr[lineIndex-1][charIndex]
        end
        # XOR char against the previous
        edgeLeft = prevChar.to_i(2) ^ currentChar.to_i(2)
        # XOR char against the top
        edgeTop = currentChar.to_i(2) ^ topChar.to_i(2)
        # if the top row has changed use the second
        edge = edgeLeft == 1 ? edgeLeft : edgeTop
        prevChar = currentChar
        result = result+"#{edge}"
     end
   result = result+"\n"
   end
   return result
end

# Please each line into an array
input = $stdin.read
arr = input.split(/\n/)
result = CalculateEdge(arr)
puts "Input :   \n#{input}"
puts "Output:   \n#{result}"
