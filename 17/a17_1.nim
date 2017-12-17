
proc run(steps: int): tuple[val: int, buf: seq[int]] =
  var buf = @[0]
  var pos = 0
  proc oneStep(i: int) =
    pos = ((steps + pos) mod buf.len) + 1
    if pos == buf.len:
      buf &= i
    else:
      buf.insert(i, pos)

  for i in 1..2017:
    oneStep(i)

  pos = (pos + 1) mod buf.len
  result.val = buf[pos]
  result.buf = buf

echo run(3)
echo run(376)

