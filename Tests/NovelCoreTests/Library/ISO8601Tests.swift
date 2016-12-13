import XCTest
import Foundation
@testable import NovelCore

class ISO8601Tests: XCTestCase {

  static let allTests = [
    ("testInit", testInit),
    ("testDate", testDate),
    ("testString", testString),
  ]

  var iso8601: ISO8601!

  override func setUp() {
    super.setUp()
    iso8601 = ISO8601()
  }

  // MARK: - Tests

  func testInit() throws {
    XCTAssertEqual(iso8601.formatter.dateFormat, "yyyy-MM-dd HH:mm:ss")
  }

  func testDate() throws {
    let date = Date()
    let string = iso8601.formatter.string(from: date)

    XCTAssertEqual(date.iso8601, string)
  }

  func testString() throws {
    let date = Date()
    let string = iso8601.formatter.string(from: date)

    XCTAssertEqual(string.iso8601?.iso8601, date.iso8601)
  }
}
