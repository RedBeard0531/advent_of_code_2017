import os
import strutils
import sequtils


var f = open("input")
var sum = 0
when false: # part one
  for line in f.lines:
    var min = int.high
    var max = int.low
    for n in line.split.map(parseInt):
      if n < min: min = n
      if n > max: max = n
    sum += max - min
else: # part 2
  for line in f.lines:
    block lines:
      var nums = line.split.map(parseInt)
      for i in 0..<nums.len:
        for j in 0..<nums.len:
          if i == j: continue
          var a = nums[i]
          var b = nums[j]
          proc divides(a, b: int): bool = a mod b == 0
          if divides(a,b):
            sum += a div b
            break lines

echo sum


f.close()
