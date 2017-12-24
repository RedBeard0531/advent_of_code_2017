import sequtils
import strutils
import strformat
import tables

let input = toSeq(lines("input")).mapIt(it.split('/').map(parseInt))

type Bucket = tuple[pieces: seq[int], available: set[range[0..7]]]
var pieces = initTable[int, Bucket]()

for piece in input:
  for a, b in [(piece[0], piece[1]), (piece[1], piece[0])].items:
    let bucket = addr pieces.mgetOrPut(a, (@[], {}))
    bucket.available.incl bucket.pieces.len
    bucket.pieces &= b

# used to calculate Bucket set size.
echo "biggest bucket=", max(toSeq(pieces.values()).mapIt(it.pieces.len))

var longest = (length: 0, score: 0)
var bestScore = 0
template hitEnd(score, length: int) =
  if score > bestScore:
    #echo score
    bestScore = score
  if (length, score) > longest:
    longest = (length, score)
    #echo longest

proc build(score, length, next: int) =
  if next notin pieces:
    hitEnd(score, length)
    return

  let bucket = addr pieces[next]
  if bucket.available == {}:
    hitEnd(score, length)
    return

  for i in bucket.available:
    let nextB = bucket.pieces[i]
    bucket.available.excl i
    var bIx = 0
    let bucketB = addr pieces[nextB]
    block markBUsed:
      for j in bucketB.available:
        if bucketB.pieces[j] == next:
          bIx = j
          bucketB.available.excl j
          break markBUsed
      quit fmt"Can't find {next}/{nextB} in {bucketB[]}"
    #echo fmt"n={next} b={nextB} i={i} j={bIx}"
    let
      score = score + next + nextB
      length = length + 1
    build(score, length, nextB)
    bucket.available.incl i
    bucketB.available.incl bIx

build(0, 0, 0)

echo fmt"part1={bestScore} part2={longest.score}"
