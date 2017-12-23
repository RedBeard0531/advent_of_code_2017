import future
var a,b,c,d,e,f,h = 0
a = 1

b = 67
b *= 100
b += 100_000
c = b
c += 17_000
while true:
  f = 1
  d = 2
  block findF:
    while true:
      if b mod d == 0:
        #dump b
        #dump d
        #echo ""
        f = 0
        break findF
      d += 1
      if d == b: break
  if f == 0:
    h += 1
  if b == c: break #EXIT
  b += 17

dump h
  
