import XCTest
import Foundation
@testable import NovelCore

class RouteRepresentableTests: XCTestCase {

  static let allTests = [
    ("testRelative", testRelative),
    ("testAbsolute", testAbsolute),
    ("testNew", testNew),
    ("testShow", testShow),
  ]

  var route: RouteRepresentable!

  override func setUp() {
    super.setUp()
    route = TestRoute.users
  }

  // MARK: - Tests

  func testRelative() throws {
    XCTAssertEqual(route.relative, "/users")
  }

  func testAbsolute() throws {
    XCTAssertEqual(route.absolute, "/admin/users")
  }

  func testNew() throws {
    XCTAssertEqual(route.new(isRelative: false), "/admin/users/new")
    XCTAssertEqual(route.new(isRelative: true), "/users/new")
  }

  func testShow() throws {
    XCTAssertEqual(route.show(id: 1, isRelative: false), "/admin/users/1")
    XCTAssertEqual(route.show(id: 1, isRelative: true), "/users/1")
  }
}
