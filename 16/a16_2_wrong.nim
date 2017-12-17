import sequtils
import strutils
import tables

let steps = readFile("input").strip().split(',').mapIt((action: it[0], rest: it[1..^1]))
var buffer = toSeq('a'..'p')

var ct = initCountTable[char]()
for step in steps:
  ct.inc step.action
echo ct

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

var permutation: array[16, byte]
for i, c in buffer: permutation[i] = c.byte - 'a'.byte
echo permutation
when false: #slow
  var tmp = newSeq[char](16)
  for _ in 2..1_000_000_000:
    for i, p in permutation:
      tmp[i] = buffer[p.int]
      swap(tmp, buffer)
else:
  {.passC: "-msse -msse2 -msse3 -mssse3".}
  {.passL: "-msse -msse2 -msse3 -mssse3".}
  type m128i* {.importc: "__m128i", header: "emmintrin.h".} = object
  proc loadu_si128(p: ptr m128i): m128i
    {.importc: "_mm_loadu_si128", header: "emmintrin.h".}
  proc storeu_si128(p: ptr m128i, b: m128i): void
    {.importc: "_mm_storeu_si128", header: "emmintrin.h".}
  proc shuffle_epi8*(a: m128i, b: m128i): m128i
    {.importc: "_mm_shuffle_epi8", header: "tmmintrin.h".}

  var bvec = loadu_si128(cast[ptr m128i](addr buffer[0]))
  var pvec = loadu_si128(cast[ptr m128i](addr permutation[0]))
  for _ in 2..1_000_000_000:
    bvec = shuffle_epi8(bvec, pvec)

  storeu_si128(cast[ptr m128i](addr buffer[0]), bvec)
  

echo buffer.join # part two





