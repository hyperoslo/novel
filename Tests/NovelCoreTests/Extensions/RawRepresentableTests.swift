import XCTest
@testable import NovelCore

fileprivate enum Key: String {
  case firstName
}

class RawRepresentableTests: XCTestCase {

  static let allTests = [
    ("testSnaked", testSnaked),
    ("testValue", testValue),
  ]

  fileprivate var key: Key!

  override func setUp() {
    super.setUp()
    key = .firstName
  }

  // MARK: - Tests

  func testSnaked() throws {
    XCTAssertEqual(key.snaked, "first_name")
  }

  func testValue() throws {
    XCTAssertEqual(key.value, key.snaked)
  }
}
