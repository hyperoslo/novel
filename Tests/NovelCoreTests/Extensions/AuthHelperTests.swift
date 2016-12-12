import XCTest
import Vapor
import HTTP
import Auth
@testable import NovelCore

class AuthHelperTests: XCTestCase {

  static let allTests = [
    ("testIsAuthenticatedWithoutUser", testIsAuthenticatedWithoutUser),
  ]

  var helper: Helper!

  override func setUp() {
    super.setUp()
  }

  func testIsAuthenticatedWithoutUser() throws {
    let request = try Request(method: .get, uri: "http://novel.loc")
    helper = Helper(request: request)
    XCTAssertFalse(helper.isAuthenticated)
  }
}
