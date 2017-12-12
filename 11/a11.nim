import strutils
import sequtils
import future

let input = readFile("input").strip().split(',')

# adjusted to keep all directions positive for my input
var s, ne, se = 0
for step in input:
  case step
  of "s": inc s
  of "n": dec s
  of "ne": inc ne
  of "sw": dec ne
  of "se": inc se
  of "nw": dec se
  else: quit "bad step: " & step

dump s
dump ne
dump se

#this isn't general but matches my input
dump ne + se

