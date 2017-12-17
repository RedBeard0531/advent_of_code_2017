import sequtils
import strutils

let steps = readFile("input").strip().split(',').mapIt((action: it[0], rest: it[1..^1]))
var buffer = toSeq('a'..'p')

for step in steps:
  case step.action
  of 's':
    let size = parseInt(step.rest)
    assert size <= buffer.len
    if size < buffer.len:
      buffer = buffer[^size..^1] & buffer[0..(buffer.len - size - 1)]
  of 'x':
    let parts = step.rest.split('/').map(parseInt)
    swap(buffer[parts[0]], buffer[parts[1]])
  of 'p':
    let parts = step.rest.split('/').mapIt(buffer.find(it[0]))
    swap(buffer[parts[0]], buffer[parts[1]])
  else: quit "bad step: " & $step

echo buffer.join # part one
