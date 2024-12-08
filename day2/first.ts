#!/usr/bin/env bun

import { readFileSync } from "fs";

const increasing = (nums: number[]) =>
  nums.slice(1).every((num, i) => num >= nums[i]);


const decreasing = (nums: number[]) =>
  nums.slice(1).every((num, i) => num <= nums[i]);

const diff_geq_one_leq_three = (nums: number[]) =>
  nums.slice(1).every((num, i) => Math.abs(num - nums[i]) >= 1 && Math.abs(num - nums[i]) <= 3);

const is_safe = (nums: number[]) =>
  (increasing(nums) || decreasing(nums)) && diff_geq_one_leq_three(nums);

const data = readFileSync("input.txt", "utf8")
  .split("\n")
  .map(line => line.split(" ").map(Number))
  .filter(is_safe)

console.log(data.length);
