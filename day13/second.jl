#!/usr/bin/env julia

using LinearAlgebra

open("input.txt", "r") do f
  input = read(f, String)
  rx = r"Button A: X\+(\d+), Y\+(\d+)\nButton B: X\+(\d+), Y\+(\d+)\nPrize: X=(\d+), Y=(\d+)"
  global machines = eachmatch(rx, input) .|> m -> map((
    ax = m.captures[1],
    ay = m.captures[2],
    bx = m.captures[3],
    by = m.captures[4],
    px = m.captures[5],
    py = m.captures[6]
   )) do x parse(Int, x) // 1 end
end
costs = map(machines) do m
  A = [m.ax m.bx; m.ay m.by]
  b = [m.px; m.py] + [10000000000000 // 1; 10000000000000 // 1]
  x = inv(A) * b
  if x[1] < 0 || x[2] < 0 return 0 end
  if x[1] != float(x[1]) || x[2] != float(x[2]) return 0 end
  return x[1] * 3 + x[2]
end
costs |> sum |> println
