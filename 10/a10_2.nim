import sequtils
import strutils

let input = readFile("input").strip.mapIt(it.uint8) & @[17u8, 31, 73, 47, 23]

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

for _ in 1..64:
  for l in input:
    reverse(cur, cur+l-1)
    cur += l + skip
    inc skip

var dense: array[16, uint8]
for i, d in dense.mpairs:
  var begin = i*16
  d = buf[begin..<begin+16].foldl(a xor b)
  
echo dense
echo dense.map(toHex).join.toLowerAscii
