import strutils
import sequtils
import math
import queues

proc judge(a,b: uint, part: static[int]): int =
  var a=a
  var b=b
  let limit = if part == 1: 40_000_000 else: 5_000_000
  for _ in 1..limit:
      while true:
        a = (a * 16807) mod 2147483647
        if part == 1 or a mod 4 == 0: break
      while true:
        b = (b * 48271) mod 2147483647
        if part == 1 or b mod 8 == 0: break
      if a.uint16 == b.uint16:
          result += 1

doAssert judge(65,8921, part=1) == 588
echo judge(634, 301, part=1)

echo judge(65,8921, part=2)
echo judge(634, 301, part=2)

