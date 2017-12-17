import strutils
import sequtils
import math
let input = "hwlqcszp"

proc knot(input: string): array[16, uint8] =
    let input = input.mapIt(it.uint8) & @[17u8, 31, 73, 47, 23]
    var buf: array[0..255, uint8]
    var cur, skip: uint8
    
    for i in 0u8..255u8: buf[i] = i
    
    proc reverse(a, b: uint8) =
      var
        a = a
        b = b
      while a != b and a != b+1:
        swap(buf[a], buf[b])
        inc a
        dec b
    
    for _ in 1..64:
      for b in input:
        reverse(cur, cur+b-1)
        cur += b + skip
        inc skip
        
    for i, d in result.mpairs:
      var begin = i*16
      d = buf[begin.int..<begin+16].foldl(a xor b)
 
proc countOnes(input: string) : int =
    knot(input).mapIt(it.BiggestInt.toBin(8)).join().filterIt(it == '1').len
    
proc grid(input: string): auto =
    sum toSeq(0..<128).mapIt(countOnes(input & '-' & $it))
    
assert grid("flqrgnkx") == 8108
echo grid input
