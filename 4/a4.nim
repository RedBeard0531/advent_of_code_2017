import sets
import strutils
import future
import algorithm

const part = 2

var okLines = 0
for line in lines("input"):
  block lineBlock:
    var uniq = initSet[string]()
    for word in line.split:
      var word2 = word
      when part == 2:
        word2.sort(cmp)
      if uniq.containsOrIncl word2:
        break lineBlock
    okLines += 1

dump okLines
    
    
    
