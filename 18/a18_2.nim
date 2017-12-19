import sequtils
import strutils
import strformat
import patty
import os
import deques
import asyncdispatch
import asyncstreams
import future

echo "warning: this overflows the stack without https://github.com/nim-lang/Nim/pull/6915"

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
  Snd, Set, Add, Mul, Mod, Rcv, Jgz
type Instruction = object
  kind: InstructionKind
  x, y: Val

proc `$`(i: Instruction): string =
  return case i.kind
    of Snd, Rcv: fmt"{i.kind}({i.x})"
    else: fmt"{i.kind}({i.x}, {i.y})"
  
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

let instructions = toSeq(lines("input")).map(parseInstruction)
var queues = [newFutureStream[int]("0"), newFutureStream[int]("0")]
var inRcv = 0

proc flip(i: int): int =
  if i == 0: 1
  else: 0

var p1sends = 0
proc thread(pid: int): Future[void] =
  var registers: array['a'..'z', int]
  registers['p'] = pid
  let inPipe = queues[pid]
  let outPipe = queues[pid.flip]

  proc val(v: Val): int =
    match v:
      Imm(imm): imm
      Reg(reg): registers[reg]

  proc execOne(ip: int): Future[int] {.async.}=
    result = ip + 1
    let inst = instructions[ip]
    debug: echo fmt"{pid} executing {ip} {inst} {inst.x.val} {inst.y.val}"
    case inst.kind
    of Snd:
      debug: echo fmt"{pid} sending {inst.x.val}"
      if pid == 1: p1sends.inc
      await outPipe.write inst.x.val
    of Set: registers[inst.x.reg] = inst.y.val
    of Add: registers[inst.x.reg] = inst.x.val + inst.y.val
    of Mul: registers[inst.x.reg] = inst.x.val * inst.y.val
    of Mod: registers[inst.x.reg] = inst.x.val mod inst.y.val
    of Rcv:
      debug: echo fmt"{pid} entering recv {inPipe.len}"
      inRcv.inc
      if inPipe.len == 0 and outPipe.len == 0 and inRcv == 2:
        echo "deadlock detected"
        return -1
      
      let (haveVal, val) = await inPipe.read()
      inRcv.dec
      if not haveVal: return -1
      debug: echo fmt"{pid} recved {val}"
      registers[inst.x.reg] = val
    of Jgz:
      if inst.x.val > 0:
        result = ip + inst.y.val

  proc loop(): Future[void] {.async.} =
    var ip = 0
    while ip in 0..<instructions.len:
      ip = await execOne(ip)
    debug: echo fmt"{pid} ip {ip}"
    outPipe.complete()
  return loop()

waitFor all(thread(0), thread(1))
dump p1sends
