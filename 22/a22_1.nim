import strutils
import sequtils
import math

const
  side = 501
  start = side div 2
  totalSteps = 10_000
  inputFile = "input"
  #inputFile = "testinput"

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

  if grid[pos] == '#':
    grid[pos] = '='
  else:
    grid[pos] = '*'

  for row in grid: echo row
  echo dir
  echo ""

for _ in 1..totalSteps:
  if grid[pos] == '#':
    dir = dir.right
    grid[pos] = '.'
  else:
    dir = dir.left
    grid[pos] = '#'
    infectingBursts.inc
  pos.step(dir)
  #printGrid()

echo infectingBursts
