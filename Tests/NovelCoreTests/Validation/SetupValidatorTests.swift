import XCTest
import Vapor
@testable import NovelCore

class SetupValidatorTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
    ]

  var validator: SetupValidator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    let node = try Node(node: [
      "site_name": "Blog",
      "site_url": "http://blog.loc"
      ])
    validator = SetupValidator(node: node)
    XCTAssertTrue(validator.isValid)
  }

  func testValidateWhenInvalid() throws {
    let node = try Node(node: ["site_name": "", "site_url": ""])
    validator = SetupValidator(node: node)
    XCTAssertFalse(validator.isValid)
  }
}
