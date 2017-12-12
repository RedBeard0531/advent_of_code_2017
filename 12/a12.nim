import strutils
import sequtils
import intsets
import algorithm

var pipes: array[2000, seq[int]]

for line in lines("input"):
  let
    parts = line.split(maxSplit=2)
    pid = parts[0].parseInt
    conns = parts[2].split(", ").map(parseInt)
  pipes[pid] = conns

var
  group: set[range[0..1999]]
  ungrouped = {range[0..1999](0)..1999}
  groups = 0

proc handlePid(p: int) =
  if p in group: return
  group.incl p
  for conn in pipes[p]:
    handlePid conn

while ungrouped.card != 0:
  inc groups
  group = {}
  for lowest in ungrouped:
    handlePid lowest
    # echo lowest,' ', group.card
    # echo group
    ungrouped = ungrouped - group
    if lowest == 0: echo group.card # part 1
    break

echo groups # part 2
