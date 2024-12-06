import java.io.File

val directions = linkedMapOf(
    '^' to Pair(-1, 0),
    '>' to Pair(0, 1),
    'v' to Pair(1, 0),
    '<' to Pair(0, -1)
)
val block = '#'
val passed = 'X'

fun rotate(direction: Char) = when (direction) {
    '^' -> '>'
    '>' -> 'v'
    'v' -> '<'
    '<' -> '^'
    else -> throw IllegalArgumentException("Unknown direction: $direction")
}

class PuzzleMap(m: List<List<Char>>) {
    private val initial = m
    private var map = m.map { it.toMutableList() }.toMutableList()
    private val w = map[0].size
    private val h = map.size
    var guardPos = calcGuardPos()

    override fun toString() = map.joinToString("\n") { it.joinToString("") }

    private fun calcGuardPos() = map.asSequence()
        .mapIndexed { i, row -> row.mapIndexed { j, c -> Pair(i, j) to c } }
        .flatten()
        .filter { directions.keys.contains(it.second) }
        .map { it.first }.first()

    fun count(c: Char) = map.sumOf { row -> row.count { it == c } }

    fun move(): Boolean {
        val (i, j) = guardPos
        val guardDirection = map[i][j]
        val (di, dj) = directions[guardDirection] ?: Pair(0, 0)
        val (newI, newJ) = Pair(i + di, j + dj)
        if (!(newI in 0 until h && newJ in 0 until w)) {
            map[i][j] = passed
            return false
        }
        if (map[newI][newJ] == block) {
            map[i][j] = rotate(guardDirection)
            return move()
        }
        map[newI][newJ] = guardDirection
        map[i][j] = passed
        guardPos = Pair(newI, newJ)
        return true
    }

    fun reset() {
        map = initial.map { it.toMutableList() }.toMutableList()
        guardPos = calcGuardPos()
    }

    fun stimulate(extraBlock: Pair<Int, Int>): Boolean {
        map[extraBlock.first][extraBlock.second] = block
        val visited = mutableSetOf<Pair<Char, Pair<Int, Int>>>()
        while (move()) {
            val state = Pair(map[guardPos.first][guardPos.second], guardPos)
            if (visited.contains(state)) {
                reset()
                return true
            }
            visited.add(state)
        }
        reset()
        return false
    }
}

val input = File("input.txt").readLines().map { line -> line.toCharArray().toList() }
val map: PuzzleMap = PuzzleMap(input)
val initialPath = mutableSetOf<Pair<Int, Int>>()
while (map.move()) initialPath.add(map.guardPos)
map.reset()

val result = initialPath.filter { map.stimulate(it) }
println(result.count())
