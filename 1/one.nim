import os

var f = open("input")
var input = f.readLine()
f.close()

when false: # part one
  input &= input[0]
  var sum: int
  for i in 0..<(input.len-1):
    if input[i] == input[i+1]:
      sum += input[i].ord - '0'.ord
else: # part two
  proc `{}`(input:string, off: int): char =
    var i = off
    if i >= input.len:
      i -= input.len
    input[i]

  var mid = (input.len) div 2
  var sum: int
  for i in 0..<(input.len-1):
    if input[i] == input{i+mid}:
      sum += input[i].ord - '0'.ord

echo sum
  
