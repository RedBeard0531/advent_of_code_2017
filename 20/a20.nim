import sequtils
import strutils
import strformat
import strscans
import math
import algorithm
import tables

type
  Vec3 = tuple
    x,y,z: int
  Point = tuple
    p, v, a: Vec3

proc `+=`(a: var Vec3, b: Vec3) =
  a.x += b.x
  a.y += b.y
  a.z += b.z

proc dist(v: Vec3): int =
  sum([abs(v.x), abs(v.y), abs(v.z)])

proc parsePoint(line: string): Point =
  if not scanf(line, "p=<$i,$i,$i>, v=<$i,$i,$i>, a=<$i,$i,$i>",
      result.p.x, result.p.y, result.p.z,
      result.v.x, result.v.y, result.v.z,
      result.a.x, result.a.y, result.a.z):
    quit fmt"Bad line: {line}"

var points = toSeq(lines("input")).map(parsePoint)

# part 1
echo points.find points.sortedByIt((it.a.dist, it.v.dist, it.p.dist))[0]

proc tick() =
  var counts = initCountTable[Vec3](points.len.rightSize)
  for p in points.mitems:
    p.v += p.a
    p.p += p.v
    counts.inc p.p
  
  var newPoints = newSeqOfCap[Point](points.len)
  for p in points:
    if counts[p.p] == 1:
      newPoints &= p
  swap(points, newPoints)

for i in 1..1000: tick() # 1000 seems to be enough ticks...
echo points.len # part 2
