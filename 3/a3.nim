import strutils
import sequtils
import collections
import future
import algorithm
import math


proc solve(input: static[int]):int =
  let
    dim = input.float.sqrt.ceil.int div 2 * 2 + 1
    dim2 = dim*dim
    squares = toSeq(countup(1, dim, 2)).mapIt(it * it)
    squareIx = squares.len - 2 #lowerBound(squares, input) - 1
    innerDim = 2*squareIx + 1
    innerDim2 = innerDim*innerDim
    par = dim2 - innerDim2
    sideLen = par div 4
    halfSideLen = sideLen div 2
    side = (input - innerDim2) div sideLen
    offset = input - (side * sideLen + innerDim2)

  assert(dim mod 2 == 1, "dim must be odd")
  assert(innerDim2 == squares[squareIx], "wtf")
  assert(par mod 4 == 0, "par mod 4")
  assert(offset >= 0, "offset >= 0")

  #echo squares
  #echo squareIx
  #echo innerDim
  #echo squares[squareIx]
  #echo dim
  #echo dim2
  #echo par
  #echo side
  #echo sideLen
  #echo offset
  result = halfSideLen + abs(offset - halfSideLen)

when isMainModule:
  #echo solve 1
  const input = 312051 
  assert solve(12) == 3
  assert solve(23) == 2
  assert solve(1024) == 31
  echo solve(input)
