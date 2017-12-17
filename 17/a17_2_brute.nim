import lists

proc run(stepSize, steps: int): tuple[afterPos, afterZero: int] =
  var buf = initSinglyLinkedRing[int]()
  buf.append(0)
  var pos = buf.head
  proc oneStep(i: int) =
    for _ in 1..stepSize:
      pos = pos.next
    let oldNext = pos.next
    pos.next = newSinglyLinkedNode(i)
    pos.next.next = oldNext
    pos = pos.next

  for i in 1..steps:
    if i mod 1_000_000 == 0: echo i
    oneStep(i)

  assert buf.head.value == 0
  result.afterPos = pos.next.value
  result.afterZero = buf.head.next.value

assert run(3, 2017).afterPos == 638
echo run(376, 2017).afterPos
echo run(376, 50_000_000).afterZero

