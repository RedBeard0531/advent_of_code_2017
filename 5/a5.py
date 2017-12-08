with open("input") as f:
    nums = [int(l) for l in f]

steps = 0
pc = 0
while 0 <= pc < len(nums):
  old = nums[pc]
  if nums[pc] >= 3:
    nums[pc] -= 1
  else:
    nums[pc] += 1
  pc += old
  steps += 1

print steps
