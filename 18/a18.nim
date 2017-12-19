import sequtils
import strutils
import strformat
import patty
import os

variant Val:
  Imm(imm: int)
  Reg(reg: char)

type InstructionKind = enum
  Snd, Set, Add, Mul, Mod, Rcv, Jgz
type Instruction = object
  kind: InstructionKind
  x, y: Val

proc parseVal(s: string): Val =
  if s[0] in 'a'..'z':
    Reg(s[0])
  else:
    Imm(parseInt(s))

proc parseInstruction(s: string): Instruction =
  let parts = s.splitWhitespace
  return case parts[0]
    of "snd": Instruction(kind: Snd, x: parseVal(parts[1]))
    of "set": Instruction(kind: Set, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "add": Instruction(kind: Add, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "mul": Instruction(kind: Mul, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "mod": Instruction(kind: Mod, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "rcv": Instruction(kind: Rcv, x: parseVal(parts[1]))
    of "jgz": Instruction(kind: Jgz, x: parseVal(parts[1]), y: parseVal(parts[2]))
    else: (quit fmt"bad instruction: {s}"; Instruction())

var lastPlayed: int
var registers: array['a'..'z', int]
let instructions = toSeq(lines("input")).map(parseInstruction)

proc val(v: Val): int =
  match v:
    Imm(imm): imm
    Reg(reg): registers[reg]

var donePartOne = false
proc execOne(ip: int): int =
  result = ip + 1
  let inst = instructions[ip]
  case inst.kind
  of Snd: lastPlayed = inst.x.val
  of Set: registers[inst.x.reg] = inst.y.val
  of Add: registers[inst.x.reg] = inst.x.val + inst.y.val
  of Mul: registers[inst.x.reg] = inst.x.val * inst.y.val
  of Mod: registers[inst.x.reg] = inst.x.val mod inst.y.val
  of Rcv:
    if inst.x.val != 0:
      registers[inst.x.reg] = lastPlayed
      if not donePartOne:
        echo lastPlayed
        quit 0
  of Jgz:
    if inst.x.val > 0:
      result = ip + inst.y.val

var ip = 0
while ip in 0..<instructions.len:
  ip = execOne(ip)
