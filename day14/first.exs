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

  def countRobotsQuadrants(robots) do
    [mid_x, mid_y] = [@width, @height] |> Enum.map(&div(&1, 2))

    Enum.reduce(robots, %{}, fn r, acc ->
      quadrant =
        with [x, y, _, _] <- r do
          cond do
            x == mid_x or y == mid_y -> :none
            x < mid_x and y < mid_y -> :first
            x > mid_x and y < mid_y -> :second
            x > mid_x and y > mid_y -> :third
            x < mid_x and y > mid_y -> :fourth
          end
        end

      if quadrant != :none, do: Map.update(acc, quadrant, 1, &(&1 + 1)), else: acc
    end)
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

ans =
  Robots.countRobotsQuadrants(Robots.moveRobots(robots, 100))

IO.puts(Enum.reduce(Map.values(ans), &*/2))
