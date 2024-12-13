#!/usr/bin/env ruby

def find_region(map, cell)
  letter = map[cell[0]][cell[1]]
  region = [cell]; queue = [cell]
  while queue.any?
    i, j = queue.shift
    [[i-1, j], [i+1, j], [i, j-1], [i, j+1]].each do |i, j|
      next if i < 0 || j < 0 || i >= map.size || j >= map[0].size
      next if map[i][j] != letter
      next if region.include?([i, j])
      region << [i, j]; queue << [i, j]
    end
  end
  region
end

def find_regions(map)
  regions = []
  visited = map.map { |row| row.map { false } }
  map.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      next if visited[i][j]
      region = find_region(map, [i, j])
      region.each { |cell| visited[cell[0]][cell[1]] = true }
      regions << region
    end
  end
  regions
end

def calc_perimeter(region)
  perimeter = 0
  region.each do |cell|
    i, j = cell
    perimeter += 1 unless region.include?([i-1, j])
    perimeter += 1 unless region.include?([i+1, j])
    perimeter += 1 unless region.include?([i, j-1])
    perimeter += 1 unless region.include?([i, j+1])
  end
  perimeter
end

map = File.read("input.txt").split("\n").map(&:chars)
puts find_regions(map).map { |region| calc_perimeter(region) * region.size }.sum
