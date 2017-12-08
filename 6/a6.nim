import strutils
import sequtils
import os
import sets

var hist: seq[seq[uint8]] = @[]
var seen = initSet[seq[uint8]]()
var cur = readFile("input").splitWhitespace().mapIt(it.parseInt.uint8)

proc minIx(): tuple[ix: int, val: uint8] =
  for i in 0..<cur.len:
    if cur[i] > result.val:
      result.ix = i
      result.val = cur[i]

var i = 0
while not seen.containsOrIncl(cur):
  hist &= cur
  #echo cur
  i.inc
  var mov = minIx()
  #echo mov
  cur[mov.ix] = 0
  while mov.val != 0:
    mov.ix.inc
    if mov.ix == cur.len: mov.ix = 0
    cur[mov.ix].inc
    mov.val.dec

echo i # part 1
echo i - hist.find(cur)
  
