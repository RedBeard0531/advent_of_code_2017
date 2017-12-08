import tables
import strutils

var
  regs = initCountTable[string]()
  highestEver = int.low

for line in lines("input"):
  let
    words = line.split()
    reg = words[0]
    mul = case words[1]
      of "inc": 1
      of "dec": -1
      else: (quit "not inc or dec: " & words[1]; 1)
    val = mul * parseInt(words[2])
    condVal = regs.getOrDefault(words[4])
    rel = words[5]
    relVal = parseInt(words[6])
    doIt = case rel
      of "==": condVal == relVal
      of "!=": condVal != relVal
      of ">":  condVal >  relVal
      of ">=": condVal >= relVal
      of "<":  condVal <  relVal
      of "<=": condVal <= relVal
      else: (quit "weird relop: " & rel; true)
  assert words[3] == "if"

  if not doIt: continue
  regs.inc(reg, val)
  highestEver = max(highestEver, regs[reg])

echo regs.largest() # part 1
echo highestEver # part 2

