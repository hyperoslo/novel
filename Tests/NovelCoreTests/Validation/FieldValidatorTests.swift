import XCTest
import Vapor
@testable import NovelCore

class FieldValidatorTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
  ]

  var validator: FieldValidator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    let node = try Node(node: ["name": "Field", "handle": "field", "kind": 0])
    validator = FieldValidator(node: node)
    XCTAssertTrue(validator.isValid)
  }

  func testValidateWhenInvalid() throws {
    let node = try Node(node: ["name": "ab", "handle": "ab", "kind": -1])
    validator = FieldValidator(node: node)
    XCTAssertFalse(validator.isValid)
    XCTAssertEqual(validator.errors.count, 3)
  }
}
