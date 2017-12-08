import strutils
import sequtils
import collections
import future
import algorithm
import math

const
  dim = 13
  side = dim div 2

proc `{}`[T](input:openarray[T], off: int): char = input[off mod input.len]

var grid: array[-side..side, array[-side..side, int]]

type Point = tuple[y, x: int]

proc `[]`(g: var type(grid), p: Point): var int = g[p.y][p.x]
proc `[]=`(g: var type(grid), p: Point, val = int) = g[p.y][p.x] = val
proc `[]`(g: type(grid), p: Point): int = g[p.y][p.x]


proc printGrid() =
  for row in grid:
    echo join(row.mapIt($it), "\t")

proc fill() =
  var p = (y:0, x:0)
  var stride = 2

  let steps = [
    () => dec p.y,
    () => dec p.x,
    () => inc p.y,
    () => inc p.x,
  ]

  var i = 0
  proc set() =
    inc i
    grid[p.y][p.x] = i

  set()
  inc p.x
  inc p.y

  while true:
    for step in steps:
      for _ in 0..<stride:
        #echo p
        step()
        set()
        #printGrid()
        if p == (side, side): return
    inc p.x
    inc p.y
    stride += 2

fill()
printGrid()

