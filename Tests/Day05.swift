import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day05Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    BFFFBBFRRR
    FFFBBBFRRR
    BBFFBBFRLL
    """

  @Test func testPart1() async throws {
    let challenge = Day05(data: testData)
    #expect(String(describing: challenge.part1()) == "820")
  }

  @Test func testPart2() async throws {
    let challenge = Day05(data: testData)
    #expect(String(describing: challenge.part2()) == "0")
  }
}
