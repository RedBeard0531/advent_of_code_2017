import os
import strutils


var f = open("input")
for line in f.lines:
  echo line.split.map(parseInt)

f.close()
