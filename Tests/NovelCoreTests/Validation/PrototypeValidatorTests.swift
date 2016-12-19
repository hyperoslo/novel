import XCTest
import Vapor
@testable import NovelCore

class PrototypeValidatorTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
  ]

  var validator: PrototypeValidator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    let node = try Node(node: [
      "name": "Test",
      "handle": "test",
      "field_names": ["Field"],
      "field_handles": ["field"],
      "field_kinds": [0],
      ])

    validator = PrototypeValidator(node: node)

    XCTAssertTrue(validator.isValid)
    XCTAssertEqual(validator.fieldNodes.count, 1)
    XCTAssertEqual(validator.fieldNodes[0]["index"], 0)
    XCTAssertEqual(validator.fieldNodes[0]["name"], "Field")
    XCTAssertEqual(validator.fieldNodes[0]["handle"], "field")
    XCTAssertEqual(validator.fieldNodes[0]["kind"], "0")
  }

  func testValidateWhenInvalid() throws {
    let node = try Node(node: [
      "name": "T",
      "handle": "t",
      "field_names": ["Field"],
      "field_handles": ["field"]
      ])

    validator = PrototypeValidator(node: node)

    XCTAssertFalse(validator.isValid)
    XCTAssertEqual(validator.fieldNodes.count, 1)
    XCTAssertEqual(validator.errors.count, 3)
  }
}
