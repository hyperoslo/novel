import XCTest
import Vapor
@testable import NovelCore

class PasswordValidationTests: XCTestCase {

  static let allTests = [
    ("testValidateWhenValid", testValidateWhenValid),
    ("testValidateWhenNotMatch", testValidateWhenNotMatch),
    ("testValidateWhenInvalidCount", testValidateWhenInvalidCount)
  ]

  var validation: PasswordValidation!

  override func setUp() {
    super.setUp()
    validation = PasswordValidation(confirmation: "password")
  }

  // MARK: - Tests

  func testValidateWhenValid() throws {
    do {
      try validation.validate(input: "password")
    } catch {
      XCTFail("Should not throw error")
    }
  }

  func testValidateWhenNotMatch() throws {
    do {
      try validation.validate(input: "password1")
      XCTFail("Should throw error")
    } catch {}
  }

  func testValidateWhenInvalidCount() throws {
    do {
      try validation.validate(input: "td")
      XCTFail("Should throw error")
    } catch {}
  }
}
