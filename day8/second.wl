#!/usr/bin/env wolframscript

input = Import["input.txt", "Text"];
input = StringSplit[#, ""] & /@ StringSplit[input, "\n"];
w = Length[input]; h = Length[Part[input, 1]];
chars = DeleteElements @@ {DeleteDuplicates[Flatten[input]], {"."}};
charLocs = AssociationMap[Position[input, #] &] @ chars;
genAntinodes = Select[1 <= Part[#, 1] <= w && 1 <= Part[#, 2] <= h &] @
  Table[Part[#, 1] + x (Part[#, 1] - Part[#, 2]), {x, 0, 100}] &; (* pick a large enough number *)
antinodes = (genAntinodes[#] & /@ Permutations[charLocs[#], {2}]) & /@ chars;
antinodes = Flatten[antinodes, 2];
Print[Length[DeleteDuplicates[antinodes]]];
