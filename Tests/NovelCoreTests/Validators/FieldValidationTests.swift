import XCTest
import Vapor
@testable import NovelCore

class FieldValidationTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenInvalid", testValidateWhenInvalid),
  ]

  // MARK: - Tests

  func testValidateWhenValid() throws {
    do {
      try FieldValidation.validate(input: 0)
    } catch {
      XCTFail("Should not throw error")
    }
  }

  func testValidateWhenInvalid() throws {
    do {
      try FieldValidation.validate(input: -1)
      XCTFail("Should throw error")
    } catch {}
  }
}
