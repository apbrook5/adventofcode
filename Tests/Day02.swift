import Testing

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day02Tests {
  // Smoke test data provided in the challenge question
  let testData = """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

  @Test func testPart1() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part1()) == "2")
  }

  @Test func testPart2() async throws {
    let challenge = Day02(data: testData)
    #expect(String(describing: challenge.part2()) == "1")
  }
}
