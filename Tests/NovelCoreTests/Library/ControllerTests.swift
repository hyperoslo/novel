import XCTest
import Vapor
import HTTP
@testable import NovelCore

class ControllerTests: XCTestCase {

  static let allTests = [
    ("testRedirectWithString", testRedirectWithString),
    ("testRedirectWithRoute", testRedirectWithRoute),
    ("testRedirectWithRouteAndId", testRedirectWithRouteAndId),
    ("testRedirectWithRouteAndNoId", testRedirectWithRouteAndNoId),
  ]

  var controller: Controller!
  let drop = Droplet()

  override func setUp() {
    super.setUp()
    controller = TestController(drop: drop)
  }

  // MARK: - Tests

  func testRedirectWithString() throws {
    let response = controller.redirect(TestRoute.users.absolute) as! Response
    let expected = Response(redirect: TestRoute.users.absolute)

    XCTAssertEqual(response.status, expected.status)
    XCTAssertEqual(response.headers, expected.headers)
  }

  func testRedirectWithRoute() throws {
    let response = controller.redirect(TestRoute.users) as! Response
    let expected = Response(redirect: TestRoute.users.absolute)

    XCTAssertEqual(response.status, expected.status)
    XCTAssertEqual(response.headers, expected.headers)
  }

  func testRedirectWithRouteAndId() throws {
    let response = controller.redirect(TestRoute.users, id: 1) as! Response
    let expected = Response(redirect: TestRoute.users.absolute + "/1")
    XCTAssertEqual(response.status, expected.status)
    XCTAssertEqual(response.headers, expected.headers)
  }

  func testRedirectWithRouteAndNoId() throws {
    let response = controller.redirect(TestRoute.users) as! Response
    let expected = Response(redirect: TestRoute.users.absolute)
    XCTAssertEqual(response.status, expected.status)
    XCTAssertEqual(response.headers, expected.headers)
  }
}
