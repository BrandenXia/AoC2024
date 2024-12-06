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
    private val map = m.map { it.toMutableList() }.toMutableList()
    private val w = map[0].size
    private val h = map.size
    private var guardPos = map.asSequence()
        .mapIndexed { i, row -> row.mapIndexed { j, c -> Pair(i, j) to c } }
        .flatten()
        .filter { directions.keys.contains(it.second) }
        .map { it.first }.first()

    override fun toString() = map.joinToString("\n") { it.joinToString("") }

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
}

val input = File("input.txt").readLines().map { line -> line.toCharArray().toList() }
val map: PuzzleMap = PuzzleMap(input)
while (true)
    if (!map.move()) break

println(map.count(passed))
