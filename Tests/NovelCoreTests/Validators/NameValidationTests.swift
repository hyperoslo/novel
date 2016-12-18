import XCTest
import Vapor
@testable import NovelCore

class NameValidationTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenNotAlphanumeric", testValidateWhenNotAlphanumeric),
    ("testValidateWhenInvalidCount", testValidateWhenInvalidCount)
  ]

  // MARK: - Tests

  func testValidateWhenValid() throws {
    do {
      try NameValidation.validate(input: "test")
    } catch {
      XCTFail("Should not throw error")
    }
  }

  func testValidateWhenNotAlphanumeric() throws {
    do {
      try NameValidation.validate(input: "test>>")
      XCTFail("Should throw error")
    } catch {}
  }

  func testValidateWhenInvalidCount() throws {
    do {
      try NameValidation.validate(input: "t")
      XCTFail("Should throw error")
    } catch {}
  }
}
