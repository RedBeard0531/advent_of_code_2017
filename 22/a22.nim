import strutils
import sequtils
import strformat
import math

const
  side = 1001
  start = side div 2
  totalSteps = 10_000_000
  inputFile = "input"
  # inputFile = "testinput"

type
  Dir = enum N, S, E, W
  Point = object
    x,y: int

template `..+`[T](a,b: T): Slice = a..(a+b)
template `..+<`[T](a,b: T): Slice = a..<(a+b)

proc `[]`[T](g: T, p: Point): auto = g[p.y][p.x]
proc `[]=`[T, U](g: var T, p: Point, val: U): auto = g[p.y][p.x] = val

proc step(p: var Point, d: Dir) =
  case d
  of N: p.y.dec
  of S: p.y.inc
  of E: p.x.inc
  of W: p.x.dec

proc left(d: Dir): Dir =
  case d
  of N: W
  of S: E
  of E: N
  of W: S

proc right(d: Dir): Dir =
  case d
  of N: E
  of S: W
  of E: S
  of W: N

proc reverse(d: Dir): Dir =
  case d
  of N: S
  of S: N
  of E: W
  of W: E

var grid: array[side, string]

for row in grid.mitems:
  row = ".".repeat side

let
  input = toSeq(lines(inputFile))
  halfInLen = input.len div 2

for i, row in input.pairs:
  grid[start+i-halfInLen][start-halfInLen..+<row.len] = row
  

var infectingBursts = 0
var pos = Point(x: start, y: start)
var dir = N

proc printGrid =
  let orig = grid[pos]
  defer: grid[pos] = orig

  grid[pos] = case grid[pos]
    of '#': '='
    of '.': '*'
    of 'F': 'f'
    of 'W': 'w'
    else: (quit fmt"bad state at {pos}: {grid[pos]}"; '"')

  for row in grid: echo row
  echo dir
  echo ""

for _ in 1..totalSteps:
  case grid[pos]
  of '.':
    dir = dir.left
    grid[pos] = 'W'
  of 'W':
    dir = dir # no turn
    grid[pos] = '#'
    infectingBursts.inc
  of '#':
    dir = dir.right
    grid[pos] = 'F'
  of 'F':
    dir = dir.reverse
    grid[pos] = '.'
  else: quit fmt"bad state at {pos}: {grid[pos]}"
  pos.step(dir)
  # printGrid()

echo infectingBursts
