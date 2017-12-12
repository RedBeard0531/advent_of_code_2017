import sequtils
import strutils

let input = readFile("input").strip.split(',').mapIt(it.parseInt.uint8)

var buf: array[0..255, uint8]
var cur, skip: uint8

for i in 0u8..255: buf[i] = i

proc reverse(a, b: uint8) =
  var
    a = a
    b = b
  while a != b and a != b+1:
    swap(buf[a], buf[b])
    inc a
    dec b

for l in input:
  echo l
  echo buf
  reverse(cur, cur+l-1)
  cur += l + skip
  inc skip

echo buf
echo buf[0].int * buf[1].int
