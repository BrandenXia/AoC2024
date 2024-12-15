defmodule Robots do
  @width 101
  @height 103

  def moveRobot(robot, sec) do
    [x, y, vx, vy] = robot
    [Integer.mod(x + vx * sec, @width), Integer.mod(y + vy * sec, @height), vx, vy]
  end

  def moveRobots(robots, sec) do
    Enum.map(robots, &moveRobot(&1, sec))
  end

  def toGrid(robots) do
    Enum.reduce(robots, List.duplicate(0, @width * @height), fn robot, acc ->
      [x, y, _, _] = robot
      List.replace_at(acc, y * @width + x, 1)
    end)
  end

  def checkChristmas(grid) do
    grid
    |> Enum.chunk_by(& &1)
    |> Enum.any?(fn chunk -> length(chunk) >= 10 && hd(chunk) == 1 end)
  end

  def findChristmas(robots, sec) do
    r_ = moveRobots(robots, 1)

    if checkChristmas(toGrid(r_)) do
      IO.puts("Sec: #{sec + 1}")
    else
      findChristmas(r_, sec + 1)
    end
  end
end

input = File.read!("input.txt")
re = ~r/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/

robots =
  Regex.scan(re, input)
  |> Enum.map(fn m ->
    [_ | tail] = m
    Enum.map(tail, &String.to_integer/1)
  end)

Robots.findChristmas(Robots.moveRobots(robots, 6000), 6000)
