#import re except toSeq
import sets
import sequtils
import strutils
import tables
import math
import future
import pegs except toSeq

let p = peg"""
msg <- {name} " (" {digits} ')' rest?$
digits <- \d+
name <- \w+
rest <- " -> " {name} children
children <- (", " {name})*
"""

type Node = ref object 
  name: string
  weight: int
  totalWeight: int
  children: seq[string]

var
  nodeSet = initSet[string]()
  children = initSet[string]()
  nodes = newTable[string, Node]()

#let RE = re"(\w+)\s\((\d+)\)(?:\s->\s(.*))?$"
for line in lines("input"):
  var node = new(Node)
  if line =~ p:
    #echo @matches
    node.name = matches[0]
    node.weight = matches[1].parseInt
    node.children = @[]
    for i in 2..matches.high:
      if matches[i].isNil: break
      node.children &= matches[i]
  else:
    quit "Bad Line: " & line
  nodes[node.name] = node
  nodeSet.incl node.name
  for c in node.children: children.incl c

let roots = nodeSet - children
assert roots.len == 1
let root = sequtils.toSeq(roots.items)[0]
echo root, "\n----\n" #part 1
proc computeWeights(n: Node): int =
  n.totalWeight = n.weight + n.children.mapIt(nodes[it].computeWeights()).sum()
  n.totalWeight

discard computeWeights nodes[root]

proc `*`(s: string, c:Natural): string = repeat(s, c)

proc print(n:Node, depth = 0) =
  echo " " * depth, ' ', n.totalWeight, ' ', n.name, ' ' , n.weight
  for c in n.children:
    print nodes[c], depth + 4

#print nodes["pidgnp"]

proc findImbalance(n: Node) =
  let weights = n.children.mapIt(nodes[it].totalWeight)
  #echo n[], weights
  for c in n.children:
    findImbalance(nodes[c])
  if not weights.allIt(it == weights[0]):
    for n in n.children.mapIt(nodes[it]): echo n[]
    echo n[], weights
    echo "---"
    assert weights.len >= 3 # or else can't tell who is wrong.
    let trustIx = if weights[0] == weights[1]: 0 else: 2
    for i in 0..<weights.len:
      if weights[i] != weights[trustIx]:
        let off = weights[trustIx] - weights[i]
        let bad = nodes[n.children[i]]
        echo bad[]
        echo ">  ", bad.weight + off, "  <"
        quit()

findImbalance(nodes[root])

