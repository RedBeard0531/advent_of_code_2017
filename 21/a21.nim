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

proc width(str: string): int =
  case str.len
  of 4: return 2
  of 9: return 3
  of 16: return 4
  else: raiseAssert fmt"Bad str {str}"

proc findRule(origKey: string): string =
  var key = origKey
  let width = key.width

  for rotation in 0..<4:
    for flip in 0..<2:
      var tmp = rules.getOrDefault(key)
      if tmp != nil:
        when defined(release):
           return tmp
        else:
          # do some extra checking
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
  let stride = 
    if state.len mod 2 == 0: 2
    else: 3

  result = @[]
  for row in countup(0, state.len-1, stride):
    result &= sequtils.repeat("", stride + 1)
    for column in countup(0, state.len-1, stride):
      let sq = toSeq(row..<row+stride).mapIt(state[it][column..<column+stride]).join()
      let rule = findRule(sq)
      for i in 0..stride:
        let ruleCol = i * (stride + 1)
        #echo rule[ruleCol..ruleCol+stride]
        result[^(stride-i+1)] &= rule[ruleCol..ruleCol+stride]

var state = @[".#.", "..#", "###"]
for tick in 1..18:
  state = state.tick
  dump state
  echo tick, ' ', state.join.count('#') # part one