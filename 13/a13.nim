import sequtils
import strutils
import math

type Scanner = tuple[depth, range, period: int]
var scanners: seq[Scanner] = @[]

for line in lines("input"):
  var parts = line.split(": ").map(parseInt)
  scanners &= (parts[0], parts[1], (parts[1]-1)*2)

proc hits(delay: int): seq[Scanner] =
  scanners.filterIt((it.depth + delay) mod it.period == 0)

echo sum hits(0).mapIt(it.depth * it.range) # part 1

for i in 0..int.high:
  if hits(i).len == 0:
    echo i # part 2
    break
