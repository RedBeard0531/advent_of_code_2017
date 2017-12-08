import sequtils
import strutils
import os

proc main() =
  var nums: seq[int] = toSeq(lines("input")).mapIt(it.parseInt)

  var steps = 0
  var pc = 0
  while pc in 0..<nums.len:
    let old = nums[pc]
    when false: # part 1
      nums[pc].inc
    else: # part 2
      if nums[pc] >= 3:
        nums[pc].dec
      else:
        nums[pc].inc
    pc += old
    steps.inc

  echo steps

main()
  
