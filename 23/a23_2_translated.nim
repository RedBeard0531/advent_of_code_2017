var a,b,c,d,e,f,g,h = 0

a = 1
b = 67
b *= 100
b += 100_000
c = b
c += 17_000
while true:
  f = 1
  d = 2
  while true:
    e = 2
    while true:
      g = d
      g *= e
      g -= b
      if g == 0:
        f = 0
      e += 1
      g = e
      g -= b
      if g == 0: break
    d += 1
    g = d
    g -= b
    if g == 0: break
  if f == 0:
    h += 1
  g = b
  g -= c
  if g == 0: break #EXIT
  b += 17

  
