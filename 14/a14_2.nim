import strutils
import sequtils
import math
import queues

let input = "hwlqcszp"

proc knot(input: string): array[16, uint8] =
    let input = input.mapIt(it.uint8) & @[17u8, 31, 73, 47, 23]
    var buf: array[0..255, uint8]
    var cur, skip: uint8
    
    for i in 0u8..255u8: buf[i] = i
    
    proc reverse(a, b: uint8) =
      var
        a = a
        b = b
      while a != b and a != b+1:
        swap(buf[a], buf[b])
        inc a
        dec b
    
    for _ in 1..64:
      for b in input:
        reverse(cur, cur+b-1)
        cur += b + skip
        inc skip
        
    for i, d in result.mpairs:
      var begin = i*16
      d = buf[begin.int..<begin+16].foldl(a xor b)
    
proc grid(input: string): array[128, array[128, int]] =
    for i, sub in result.mpairs:
        let row = knot(input & '-' & $i).mapIt(it.BiggestInt.toBin(8)).join()
        for i, c in row:
            sub[i] = c.ord - '0'.ord

type Pt = tuple[x, y: int]
proc regions(input: string): int =
    var next = 2
    var g = grid input
    proc chase(seedPt: Pt) =
        var marker = next
        inc next
        var q = initQueue[Pt]()
        q.add(seedPt)
        while q.len != 0:
            let p = q.pop()
            if p.x notin 0..<128 or p.y notin 0..<128: continue
            if g[p.y][p.x] in [0, marker]: continue
            g[p.y][p.x] = marker
            q.add((p.x, p.y-1))
            q.add((p.x, p.y+1))
            q.add((p.x-1, p.y))
            q.add((p.x+1, p.y))
    for x in 0..<128:
        for y in 0..<128:
            chase((x,y))
            
    assert next <= uint16.high.int
    var uniques: set[uint16]
    for x in 0..<128:
        for y in 0..<128:
            uniques.incl g[x][y].uint16
    uniques.excl 0
    return uniques.card
assert regions("flqrgnkx") == 1242
echo regions input


