import sequtils
import strutils
import tables
import patty
import bitops

# Make AVX/SSE ops available
{.passC: "-msse -msse2 -msse3 -mssse3 -mavx -march=native -mtune=native -flto".}
{.passL: "-msse -msse2 -msse3 -mssse3 -mavx -flto".}
type m128i* {.importc: "__m128i", header: "emmintrin.h".} = object
proc loadu_si128(p: ptr m128i): m128i
  {.importc: "_mm_loadu_si128", header: "emmintrin.h".}
proc storeu_si128(p: ptr m128i, b: m128i): void
  {.importc: "_mm_storeu_si128", header: "emmintrin.h".}
proc shuffle_epi8*(a: m128i, b: m128i): m128i
  {.importc: "_mm_shuffle_epi8", header: "tmmintrin.h".}
proc cmpeq_epi8*(a: m128i, b: m128i): m128i
  {.importc: "_mm_cmpeq_epi8", header: "emmintrin.h".}
proc movemask_epi8*(a: m128i): int32
  {.importc: "_mm_movemask_epi8", header: "emmintrin.h".}

# Build the tables used for 
proc makeShuffles: array[16, array[16, byte]] {.compileTime.}=
  for i in 0..<16:
    for j in 0..<16:
      result[i][j] = ((j + 16 - i) mod 16).byte
let shuffles = makeShuffles()

proc makeXchgs: array[16, array[16, array[16, byte]]] {.compileTime.}=
  for i in 0..<16:
    for j in 0..<16:
      for x in  0..<16:
        result[i][j][x] = x.byte
      result[i][j][i] = j.byte
      result[i][j][j] = i.byte
let xchgs = makeXchgs()

proc makeSelectors: array[16, array[16, byte]] {.compileTime.} =
  for i in 0..<16:
    for j in 0..<16:
      result[i][j] = 'a'.byte + i.byte
let selectors = makeSelectors()

variant(Step):
  Shuffle(size: int)
  Xchg(x: int, y: int)
  Pivot(a: int, b: int)

#parse the input
var steps = newSeq[Step]()
for raw in readFile("input").strip().split(',').mapIt((action: it[0], rest: it[1..^1])):
  case raw.action
  of 's':
    let size = parseInt(raw.rest)
    if size < 16:
      steps &= Shuffle(size)
  of 'x':
    var parts = raw.rest.split('/').map(parseInt)
    steps &= Xchg(parts[0], parts[1])
  of 'p':
    let parts = raw.rest.split('/').mapIt(it[0])
    steps &= Pivot(parts[0].int - 'a'.int, parts[1].int - 'a'.int)
  else: quit "bad step: " & $raw
  
type Buffer = object {.union.}
  bytes: array[16, char]
  vec: m128i
var buffer: Buffer
for i, c in toSeq('a'..'p'):
  buffer.bytes[i] = c

# This func does one full run of the input
proc run =
  var vec = buffer.vec
  for step in steps:
    {.unroll: 4.}
    match step:
      Shuffle(size):
        var pvec = loadu_si128(cast[ptr m128i](unsafeAddr shuffles[size][0]))
        vec = shuffle_epi8(vec, pvec)
      Xchg(i, j):
        var pvec = loadu_si128(cast[ptr m128i](unsafeAddr xchgs[i][j][0]))
        vec = shuffle_epi8(vec, pvec)
      Pivot(a, b):
        let avec = loadu_si128(cast[ptr m128i](unsafeAddr selectors[a][0]))
        let bvec = loadu_si128(cast[ptr m128i](unsafeAddr selectors[b][0]))
        let i = cmpeq_epi8(vec, avec).movemask_epi8.countTrailingZeroBits
        let j = cmpeq_epi8(vec, bvec).movemask_epi8.countTrailingZeroBits
        var pvec = loadu_si128(cast[ptr m128i](unsafeAddr xchgs[i][j][0]))
        vec = shuffle_epi8(vec, pvec)
  buffer.vec = vec

# one BILLION times!
for i in 0..<1_000_000_000:
  run()
  if i==0:
    echo buffer.bytes.join # part one

echo buffer.bytes.join # part two
