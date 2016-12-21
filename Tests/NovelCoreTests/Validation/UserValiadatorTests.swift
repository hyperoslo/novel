import XCTest
import Vapor
@testable import NovelCore

class UserValidatorTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
  ]

  var validator: UserValidator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    let node = try Node(node: [
      "username": "test",
      "email": "test@example.org",
      "firstname": "John",
      "lastname": "Doe",
      "password": "password",
      "password_confirmation": "password",
    ])
    validator = UserValidator(node: node)
    XCTAssertTrue(validator.isValid)
  }

  func testValidateWhenInvalid() throws {
    let node = try Node(node: [
      "username": "",
      "email": "testexample.org",
      "firstname": "J",
      "lastname": "D",
      "password": "pass",
      "password_confirmation": "password",
      ])
    validator = UserValidator(node: node)
    XCTAssertFalse(validator.isValid)
    XCTAssertEqual(validator.errors.count, 5)
  }
}
