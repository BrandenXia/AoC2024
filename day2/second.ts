#!/usr/bin/env bun

import { readFileSync } from "fs";

const increasing = (nums) =>
  nums.slice(1).every((num, i) => num > nums[i]);

const decreasing = (nums) =>
  nums.slice(1).every((num, i) => num < nums[i]);

const diff_geq_one_leq_three = (nums) =>
  nums.slice(1).every((num, i) => Math.abs(num - nums[i]) >= 1 && Math.abs(num - nums[i]) <= 3);

const is_safe = (nums) =>
  (increasing(nums) || decreasing(nums)) && diff_geq_one_leq_three(nums);

const canBeMadeSafe = (nums) => {
  for (let i = 0; i < nums.length; i++) {
    const newSequence = nums.slice(0, i).concat(nums.slice(i + 1));
    if (is_safe(newSequence)) return true;
  }
  return false;
};

const data = readFileSync("input.txt", "utf8")
  .trim()
  .split("\n")
  .map(line => line.split(" ").map(Number))
  .filter(nums => is_safe(nums) || canBeMadeSafe(nums));

console.log(data.length);
