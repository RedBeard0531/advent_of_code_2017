import strutils
import sequtils
import future

let input = toSeq(lines("input"))[0]

var
  depth = 0
  score = 0
  garbage = 0
  i = 0

proc prefixPrint(s: string) =
  echo repeat("  ", depth-1), s

proc parseInput

proc skipGarbage =
  inc depth
  let start = i
  assert input[i] == '<'
  while true:
    inc i
    case input[i]
    of '>':
      prefixPrint input[start..i]
      inc i
      dec depth
      return
    of '!': inc i
    else: inc garbage
    
proc parseGroup =
  assert input[i] == '{'
  inc i
  inc depth
  inc score, depth
  if input[i] == '}':
    prefixPrint "{}"
  else:
    prefixPrint "{"
    while true:
      parseInput()
      case input[i]
      of ',': inc i
      of '}': break
      else: raise newException(Exception, "Bad end")
    prefixPrint "}"
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


