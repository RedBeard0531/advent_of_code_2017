import tables
import sequtils
import strutils
import strformat
import future
import math

# These are the indexes to swap to perform the transformations.
# I worked them out with pencil and paper. I omitted no-op self swaps.
const 
  flip2 = [(0,1), (1,0), (2,3), (3,2)]
  flip3 = [(0,2), (2,0), (3,5), (5,3), (6,8), (8,6)]
  flipTable: array[2..3, seq[(int,int)]] = [@flip2, @flip3]
  rotate2 = [(0,2), (1,0), (2,3), (3,1)]
  rotate3 = [(0,6), (1,3), (2,0), (3,7), (5,1), (6,8), (7,5), (8,2)]
  rotateTable: array[2..3, seq[(int,int)]] = [@rotate2, @rotate3]

  corners = [[0,1,4,5], [2,3,6,7], [8,9,12,13], [10,11,14,15]]

let rules = toSeq(lines("input"))
  .mapIt(it.split(" => ").mapIt(it.replace("/", "")))
  .mapIt((it[0], it[1]))
  .toTable

proc transform(s: var string, swaps: openarray[(int, int)]) =
  var tmp = s
  for a, b in swaps.items:
    tmp[a] = s[b]
  #echo fmt"{s} | {tmp} | {@swaps}"
  s = tmp

proc width(key: string): int =
  case key.len
  of 4: return 2
  of 9: return 3
  else: raiseAssert fmt"Bad key {key}"

proc findRule(origKey: string): string =
  var key = origKey
  let width = key.width

  for rotation in 0..<4:
    for flip in 0..<2:
      var tmp = rules.getOrDefault(key)
      if tmp != nil:
        if tmp == result: continue
        #echo fmt"{rotation} {flip} {origKey} => {key} => {tmp}"
        assert key.count('#') == origKey.count('#')
        assert result == nil # detect duplicate matches
        result = tmp

      key.transform(flipTable[width])
    key.transform(rotateTable[width])
  if result == nil:
    echo key, ' ', origKey
    assert key == origKey
    quit fmt"no rule for key {key}"
        

proc tick(state: seq[string]): seq[string] =
  result = @[]
  let width = state[0].width
  for sq in state:
    let rule = findRule(sq)
    if width == 2:
      result &= rule
      continue
    for corner in corners: ########## XXX need to put all corners from all inputs in correct order!
      var s = newString(4)
      for i, a in corner:
        s[i] = rule[a]
      result &= s
    #echo fmt"{rule} => {result[^4..^1]}"
    assert rule.count('#') == result[^4..^1].join.count('#')

proc shuffleIfNeeded(state: seq[string]): seq[string] =
  if state[0].width == 2: return state
  if sum(state.mapIt(it.len)) mod 4 != 0: return state

  # convert 3s to 2s
  result = @[]
  let joined = state.join
  let sideLen = joined.len.float.sqrt.int
  var square: seq[string] = @[]
  for i in 0..<sideLen:
    let start = i * sideLen
    square &= joined[start..<(start+sideLen)]
  for x in countup(0,sidelen-1, 2):
    for y in countup(0,sidelen-1, 2):
      result &= square[y][x..x+1] & square[y+1][x..x+1]

var state = @[".#...####"]
for tick in 1..6:
  state = state.tick.shuffleIfNeeded

  echo tick, ' ', state.join.count('#') # part one

      
    
