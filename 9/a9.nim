import parseutils
import sequtils
import future

let input = toSeq(lines("input"))[0]

var
  depth = 0
  score = 0
  garbage = 0
  i = 0

proc parseInput

proc skipGarbage =
  assert input[i] == '<'
  while true:
    inc i
    case input[i]
    of '>':
      inc i
      return
    of '!': inc i
    else: inc garbage
    
proc parseGroup =
  assert input[i] == '{'
  inc depth
  inc score, depth
  inc i
  while input[i] != '}':
    parseInput()
    case input[i]
    of ',': inc i
    of '}': break
    else: raise newException(Exception, "Bad end")
  dec depth
  inc i

proc parseInput =
  case input[i]
  of '{': parseGroup()
  of '<': skipGarbage()
  else: raise newException(Exception, "Bad input")

try:
  parseInput()
  assert i == input.len
  dump score
  dump garbage
except Exception as e:
  echo e.msg
  echo getStackTrace e
  dump i
  dump depth
  dump score
  dump input[i]
  if i >= 10: dump input[i-10..i]
  dump input[i..i+10]
  quit 1


