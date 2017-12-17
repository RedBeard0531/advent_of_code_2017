proc run(steps: int): int =
  var cur: int
  var pos = 0
  proc oneStep(i: int) =
    pos = ((steps + pos) mod i) + 1
    if pos == 1:
      cur = i

  for i in 1..50_000_000:
    oneStep(i)

  result = cur

echo run(376)
