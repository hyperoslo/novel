import XCTest
import Vapor
@testable import NovelCore

class SettingValidatorTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
  ]

  var validator: SettingValidator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    let node = try Node(node: [
      "name": "Name",
      "handle": "name",
      "value": "value"])
    validator = SettingValidator(node: node)
    XCTAssertTrue(validator.isValid)
  }

  func testValidateWhenInvalid() throws {
    let node = try Node(node: ["name": "", "handle": "", "value": ""])
    validator = SettingValidator(node: node)
    XCTAssertFalse(validator.isValid)
  }
}
