import Algorithms

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.split(omittingEmptySubsequences: true, whereSeparator: \.isNewline).map { String($0) }
  }

  /*
   --- Day 5: Binary Boarding ---

   You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

   You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

   Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

   The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

   For example, consider just the first seven characters of FBFBBFFRLR:

   Start by considering the whole range, rows 0 through 127.
   F means to take the lower half, keeping rows 0 through 63.
   B means to take the upper half, keeping rows 32 through 63.
   F means to take the lower half, keeping rows 32 through 47.
   B means to take the upper half, keeping rows 40 through 47.
   B keeps rows 44 through 47.
   F keeps rows 44 through 45.
   The final F keeps the lower of the two, row 44.
   The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

   For example, consider just the last 3 characters of FBFBBFFRLR:

   Start by considering the whole range, columns 0 through 7.
   R means to take the upper half, keeping columns 4 through 7.
   L means to take the lower half, keeping columns 4 through 5.
   The final R keeps the upper of the two, column 5.
   So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

   Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

   Here are some other boarding passes:

   BFFFBBFRRR: row 70, column 7, seat ID 567.
   FFFBBBFRRR: row 14, column 7, seat ID 119.
   BBFFBBFRLL: row 102, column 4, seat ID 820.

   As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?

   Your puzzle answer was 987.

   The first half of this puzzle is complete! It provides one gold star: *
   */
  func part1() -> Any {
    let boardingPasses = BoardingPasses(data: entities)
    let maxSeatID = boardingPasses.getHighestSeatID()
    return maxSeatID
  }

  /*
   --- Part Two ---

   Ding! The "fasten seat belt" signs have turned on. Time to find your seat.

   It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.

   Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.

   What is the ID of your seat?

   Your puzzle answer was 603.

   Both parts of this puzzle are complete! They provide two gold stars: **
   */
  func part2() -> Any {
    let boardingPasses = BoardingPasses(data: entities)
    let mySeat = boardingPasses.findSeat()
    return mySeat
  }

  struct BoardingPass: Hashable {
    let boardingPass: String
    let rowCode: String
    let colCode: String
    var row: Int = 0
    var col: Int = 0
    var seatID: Int = 0

    init(boardingPass: String) {
      self.boardingPass = boardingPass
      guard !boardingPass.isEmpty else { fatalError("Invalid boarding pass: \(boardingPass)") }
      guard boardingPass.count == 10 else { fatalError("Invalid boarding pass: \(boardingPass)")}
      self.rowCode = String(boardingPass.prefix(7))
      self.colCode = String(boardingPass.suffix(3))
      self.row = getRow()
      self.col = getCol()
      self.seatID = getSeatID()
    }

    func getRow() -> Int {
      var rowRange: ClosedRange = 0...127
      rowCode.forEach {
        let halfRow: Int = (rowRange.upperBound + rowRange.lowerBound) / 2
        switch $0 {
          case "F":
            rowRange = rowRange.lowerBound...halfRow
          case "B":
            rowRange = (halfRow + 1)...rowRange.upperBound
          default:
            break
        }
      }
      let row = rowRange.lowerBound
      return row
    }

    func getCol() -> Int {
      var colRange:ClosedRange = 0...7
      colCode.forEach {
        let halfCol = (colRange.upperBound + colRange.lowerBound) / 2
        switch $0 {
          case "L":
            colRange = colRange.lowerBound...halfCol
          case "R":
            colRange = (halfCol + 1)...colRange.upperBound
          default:
            break
        }
      }
      let col = colRange.lowerBound
      return col
    }

    func getSeatID() -> Int {
      return (row * 8) + col
    }

  }

  struct BoardingPasses {
    var passes: [BoardingPass] = []

    init(data: [String]) {
      for line in data {
        let pass = BoardingPass(boardingPass: line)
        passes.append(pass)
      }
    }

    func getHighestSeatID() -> Int {
      let maxSeatId = passes.max(by: { $0.seatID < $1.seatID })!.seatID
      return maxSeatId
    }

    func findSeat() -> Int {
      let seatIds = Set(passes.map(\.seatID))
      let allSeats = Set(0..<1024)
      let missingSeats = allSeats.subtracting(seatIds)
      // some seats are missing but good seat with have + 1 / -1 seats in the list
      for seat in missingSeats {
        let seatAbove = seat + 1
        let seatBelow = seat - 1
        if seatIds.contains(seatAbove) && seatIds.contains(seatBelow) {
          return seat
        }
      }
      return 0
    }
  }

}
