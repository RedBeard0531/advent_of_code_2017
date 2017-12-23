import sequtils
import strutils
import strformat
import patty
import algorithm
import future

const debugging = false
template debug(body): untyped =
  when debugging: body

variant Val:
  Imm(imm: int)
  Reg(reg: char)

proc `$`(v:Val): string =
  match v:
    Imm(imm): $imm
    Reg(reg): $reg

type InstructionKind = enum
  Set, Sub, Mul, Jnz
type Instruction = object
  kind: InstructionKind
  x, y: Val

proc `$`(i: Instruction): string =
  fmt"{i.kind}({i.x}, {i.y})"
  
proc parseVal(s: string): Val =
  if s[0] in 'a'..'z':
    Reg(s[0])
  else:
    Imm(parseInt(s))

proc parseInstruction(s: string): Instruction =
  let parts = s.splitWhitespace
  return case parts[0]
    of "set": Instruction(kind: Set, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "sub": Instruction(kind: Sub, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "mul": Instruction(kind: Mul, x: parseVal(parts[1]), y: parseVal(parts[2]))
    of "jnz": Instruction(kind: Jnz, x: parseVal(parts[1]), y: parseVal(parts[2]))
    else: (quit fmt"bad instruction: {s}"; Instruction())

let instructions = toSeq(lines("input")).map(parseInstruction)
var registers: array['a'..'h', int]
var muls = 0

proc val(v: Val): int =
  match v:
    Imm(imm): imm
    Reg(reg): registers[reg]

proc execOne(ip: int): int =
  result = ip + 1
  let inst = instructions[ip]
  debug: echo fmt"{ip+1}: {inst}"
  case inst.kind
  of Set: registers[inst.x.reg] = inst.y.val
  of Sub: registers[inst.x.reg] = inst.x.val - inst.y.val
  of Mul: registers[inst.x.reg] = inst.x.val * inst.y.val; muls.inc
  of Jnz:
    if inst.x.val != 0:
      result = ip + inst.y.val

proc loop() =
  var instCount = 0
  var ip = 0
  while ip in 0..<instructions.len:
    ip = execOne(ip)
    debug:
      instCount.inc
      if instCount == 100000: quit "done"
      echo toSeq(registers.pairs).mapIt(fmt"{it[0]}:{it[1]}").join(", ")

# part 1
loop()
echo muls

# part 2
quit "part 2 can't be solved this way. See a23_2_trans_opt.nim for an optimized version of input"
registers.fill(0)
registers['a'] = 1
loop()
echo registers['h']

