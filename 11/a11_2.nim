import strutils
import sequtils
import future
import algorithm
import math

let input = readFile("input").strip().split(',')

var a = [0,0,0] # s, ne, se

proc dist: int = sum a.mapIt(it.abs).sorted(cmp)[1..2]

var maxDist = 0
for step in input:
  case step
  of "s": inc a[0]
  of "n": dec a[0]
  of "ne": inc a[1]
  of "sw": dec a[1]
  of "se": inc a[2]
  of "nw": dec a[2]
  else: quit "bad step: " & step
  maxDist = max(maxDist, dist())

echo "current dist: ", dist() # part 1
echo "max dist: ", maxDist
  


