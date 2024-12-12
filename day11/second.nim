import std/[math, strutils, tables]

proc readInput(): Table[int, int] = 
  result = initTable[int, int]()
  let f = open("input.txt")
  defer: f.close()
  let line = f.readLine()
  let nums = split(line, " ")
  for i in 0..<len(nums):
    let num = strutils.parseInt(nums[i])
    result[num] = result.getOrDefault(num, 0) + 1

proc procStone(s: int): seq[int] = 
  let s_str = $s
  if s == 0:
    return @[1]
  elif len(s_str) mod 2 == 0:
    let mid = len(s_str) div 2
    let left = strutils.parseInt(s_str[0..mid-1])
    let right = strutils.parseInt(s_str[mid..^1])
    return @[left, right]
  else:
    return @[s * 2024]

proc procStones(count: int, stones: Table[int, int]): Table[int, int] = 
  var tmp = stones
  for _ in 0..<count:
    var newStones = initTable[int, int]()
    for stone, count in tmp:
      for r in procStone(stone):
        newStones[r] = newStones.getOrDefault(r, 0) + count
    tmp = newStones
  return tmp

let stones = procStones(75, readInput())
var sum = 0
for s in stones.values:
  sum += s
echo sum
