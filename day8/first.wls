#!/usr/bin/env wolframscript

input = Import["input.txt", "Text"];
input = StringSplit[#, ""] & /@ StringSplit[input, "\n"];
w = Length[input]; h = Length[Part[input, 1]];
chars = DeleteElements @@ {DeleteDuplicates[Flatten[input]], {"."}};
charLocs = AssociationMap[Position[input, #] &] @ chars;
antinodes = (2  Part[#, 1] - Part[#, 2] & /@ Permutations[charLocs[#], {2}]) & /@ chars;
antinodes = Flatten[antinodes, 1];
antinodes = Select[1 <= Part[#, 1] <= w && 1 <= Part[#, 2] <= h &] @ antinodes;
Print[Length[DeleteDuplicates[antinodes]]]
