import sequtils
import strutils
import strformat

let input = toSeq(lines("input"))

type
  Direction = tuple[dim, pol: int]
  Point = array[2, int]

proc `[]`(grid: seq[string], pos: Point): char = grid[pos[0]][pos[1]]
proc contains(grid: seq[string], pos: Point): bool =
  pos[0] in 0..<input.len and pos[1] in 0..<input[pos[0]].len

var letters = ""
var pos: Point = [0, input[0].find('|')]
var dir: Direction = (dim: 0, pol: 1)
var steps = 0 # I count final step off path rather than including start

while true:
  steps.inc
  pos[dir.dim] += dir.pol
  if pos notin input: break
  case input[pos]
  of ' ': break
  of 'A'..'Z': letters &= input[pos]; continue
  of '-', '|': continue
  of '+': discard # handled below
  else: quit fmt"bad symbol: {input[pos]}"

  dir.dim = (if dir.dim == 0: 1 else: 0)
  let expected = (if dir.dim == 0: '|' else: '-')
  for pol in [1,-1, 0]:
    if pol == 0: quit fmt"got lost at {pos}"
    var newPos = pos
    newPos[dir.dim] += pol
    if newPos notin input: continue
    if input[newPos] == expected:
      dir.pol = pol
      break

echo letters # part 1
echo steps # part 2
