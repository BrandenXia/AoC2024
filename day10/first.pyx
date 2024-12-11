from collections import deque

from libc.stdlib cimport calloc, free

DEF INPUT = "input.txt"
DEF ZERO = ord("0")

cdef class Map:
    cdef unsigned int * grid
    cdef unsigned int h, w

    def __cinit__(self):
        with open(INPUT, "r") as f:
            self.h = len(f.readlines())
            f.seek(0)
            self.w = len(f.readline().strip())
            self.grid = <unsigned int *> calloc(self.h * self.w, sizeof(unsigned int))
            f.seek(0)
            for i from 0 <= i < self.w * self.h:
                if (c := f.read(1)) != "\n":
                    self.grid[i] = ord(c) - ZERO
                else:
                    i -= 1

    def __dealloc__(self):
        free(self.grid)

    def __repr__(self):
        s = ""
        for i in range(self.h):
            for j in range(self.w):
                s += str(self.grid[i * self.w + j])
            s += "\n"
        return s

    def __getitem__(self, (unsigned int, unsigned int) p) -> int:
        return self.grid[p[0] * self.w + p[1]]

    def __iter__(self):
        for i in range(self.h):
            for j in range(self.w):
                yield i, j

cdef find_trailheads(m):
    return filter(lambda p: m[p] == 0, m)

cdef bfs(Map m, start):
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    queue = deque([start])
    visited = set()
    visited.add(start)
    nines_reachable = set()
    while queue:
        x, y = queue.popleft()
        current_height: int = m[x, y]
        if current_height == 9:
            nines_reachable.add((x, y))
        for dx, dy in directions:
            nx, ny = x + dx, y + dy
            if 0 <= nx < m.h and 0 <= ny < m.w:
                if (nx, ny) not in visited and m[nx, ny] == current_height + 1:
                    visited.add((nx, ny))
                    queue.append((nx, ny))
    return nines_reachable

cdef calc_total_score(Map m):
    cdef unsigned int total = 0
    for t in find_trailheads(m):
        total += len(bfs(m, t))
    return total

cdef void main():
    cdef Map m = Map()
    print(calc_total_score(m))
    del m

main()
