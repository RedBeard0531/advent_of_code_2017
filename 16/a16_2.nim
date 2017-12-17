import sequtils
import strutils
import tables
import patty

var seen = initTable[array[16,char], int]()

{.passC: "-msse -msse2 -msse3 -mssse3 -mavx -march=native -mtune=native -flto".}
{.passL: "-msse -msse2 -msse3 -mssse3 -mavx -flto".}
type m128i* {.importc: "__m128i", header: "emmintrin.h".} = object
proc loadu_si128(p: ptr m128i): m128i
  {.importc: "_mm_loadu_si128", header: "emmintrin.h".}
proc storeu_si128(p: ptr m128i, b: m128i): void
  {.importc: "_mm_storeu_si128", header: "emmintrin.h".}
proc shuffle_epi8*(a: m128i, b: m128i): m128i
  {.importc: "_mm_shuffle_epi8", header: "tmmintrin.h".}

proc makeShuffles: array[16, array[16, byte]] =
  for i in 0..<16:
    for j in 0..<16:
      result[i][j] = ((j + 16 - i) mod 16).byte

let shuffles = makeShuffles()

variant(Step):
  Shuffle(size: int)
  Xchg(x: int, y: int)
  Pivot(a: char, b: char)

var steps = newSeq[Step]()
for raw in readFile("input").strip().split(',').mapIt((action: it[0], rest: it[1..^1])):
  case raw.action
  of 's':
    let size = parseInt(raw.rest)
    if size < 16:
      steps &= Shuffle(size)
  of 'x':
    let parts = raw.rest.split('/').map(parseInt)
    steps &= Xchg(parts[0], parts[1])
  of 'p':
    let parts = raw.rest.split('/').mapIt(it[0])
    steps &= Pivot(parts[0], parts[1])
  else: quit "bad step: " & $raw
  
type Buffer = object {.union.}
  bytes: array[16, char]
  vec: m128i
var buffer: Buffer
for i, c in toSeq('a'..'p'):
  buffer.bytes[i] = c

proc run =
  for step in steps:
    match step:
      Shuffle(size):
        var pvec = loadu_si128(cast[ptr m128i](unsafeAddr shuffles[size][0]))
        buffer.vec = shuffle_epi8(buffer.vec, pvec)
      Xchg(i, j):
        swap(buffer.bytes[i], buffer.bytes[j])
      Pivot(a, b):
        swap(buffer.bytes[buffer.bytes.find(a)], buffer.bytes[buffer.bytes.find(b)])


for i in 0..<1_000_000_000:
  if seen.hasKeyOrPut(buffer.bytes, i):
    let first = seen[buffer.bytes]
    echo i, ' ', first
    let additionalTimes = (1_000_000_000 - first) mod (i - first)
    echo additionalTimes
    for _ in 1..additionalTimes:
      run()
    break
  run()
  if i == 0: echo buffer.bytes.join # part one

echo buffer.bytes.join # part two
