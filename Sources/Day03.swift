import Algorithms

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(omittingEmptySubsequences: true, whereSeparator: \.isNewline).map { String($0) }
  }

  /*
   --- Day 3: Toboggan Trajectory ---

   With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

   Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

   ..##.......
   #...#...#..
   .#....#..#.
   ..#.#...#.#
   .#...##..#.
   ..#.##.....
   .#.#.#....#
   .#........#
   #.##...#...
   #...##....#
   .#..#...#.#
   These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

   ..##.........##.........##.........##.........##.........##.......  --->
   #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
   .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
   ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
   .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
   ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
   .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
   .#........#.#........#.#........#.#........#.#........#.#........#
   #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
   #...##....##...##....##...##....##...##....##...##....##...##....#
   .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
   You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

   The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

   From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

   The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

   ..##.........##.........##.........##.........##.........##.......  --->
   #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
   .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
   ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
   .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
   ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
   .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
   .#........#.#........X.#........#.#........#.#........#.#........#
   #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
   #...##....##...##....##...#X....##...##....##...##....##...##....#
   .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
   In this example, traversing the map using this slope would cause you to encounter 7 trees.

   Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?

   Your puzzle answer was 278.

   The first half of this puzzle is complete! It provides one gold star: *
   */
  func part1() -> Any {
    let trees = TreeMap(data: entities)
    let result = trees.countTrees(slope: .init(3, 1))
    return result
  }

  /*
   --- Part Two ---

   Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

   Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

   Right 1, down 1.
   Right 3, down 1. (This is the slope you already checked.)
   Right 5, down 1.
   Right 7, down 1.
   Right 1, down 2.
   In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

   What do you get if you multiply together the number of trees encountered on each of the listed slopes?

   Your puzzle answer was 9709761600.

   Both parts of this puzzle are complete! They provide two gold stars: **
   */
  func part2() -> Any {
    let slopes: [Coordinate] = [.init(1, 1,), .init(3, 1), .init(5, 1), .init(7, 1), .init(1, 2)]
    let trees = TreeMap(data: entities)
    let result = slopes.map( { trees.countTrees(slope: $0) } ).reduce(1, *)
    return result
  }

  struct Coordinate: Hashable, Comparable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
      self.x = x
      self.y = y
    }

    static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
      return Coordinate(lhs.x + rhs.x, lhs.y + rhs.y)
    }

    static func < (lhs: Coordinate, rhs: Coordinate) -> Bool {
      return lhs.y == rhs.y ? lhs.x < rhs.x : lhs.y < rhs.y
    }

    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
      return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func move(slope: Coordinate, width: Int) -> Coordinate {
      let newX = (x + slope.x) % width
      return .init(newX, y + slope.y)
    }

  }

  struct TreeMap {
    var trees: Set<Coordinate> = []
    let width: Int
    let height: Int

    init(data: [String]) {
      self.width = data.first!.count
      self.height = data.count
      for (y, line) in data.enumerated() {
        for (x, char) in line.enumerated() {
          if char == "#" {
            trees.insert(.init(x, y))
          }
        }
      }
    }

    func countTrees(slope: Coordinate) -> Int {
      var position: Coordinate = .init(0, 0)
      var count: Int = 0
      while position.y < height {
        if trees.contains(position) {
          count += 1
        }
        position = position.move(slope: slope, width: self.width)
      }
      return count
    }

  }




}
