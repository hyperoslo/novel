import XCTest
import Vapor
@testable import NovelCore

class EntryValidatorTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
  ]

  var validator: EntryValidator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    let node = try Node(node: ["title": "Title"])
    validator = EntryValidator(node: node)
    XCTAssertTrue(validator.isValid)
  }

  func testValidateWhenInvalid() throws {
    let node = try Node(node: ["title": ""])
    validator = EntryValidator(node: node)
    XCTAssertFalse(validator.isValid)
  }
}
