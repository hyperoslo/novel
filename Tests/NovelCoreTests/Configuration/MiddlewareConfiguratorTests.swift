import XCTest
import Vapor
import Auth
@testable import NovelCore

class MiddlewareConfiguratorTests: XCTestCase {

  static let allTests = [
    ("testConfigure", testConfigure),
  ]

  var configurator: MiddlewareConfigurator!

  override func setUp() {
    super.setUp()
    configurator = MiddlewareConfigurator()
  }

  // MARK: - Tests

  func testConfigure() throws {
    let drop = createDroplet()
    try configurator.configure(drop: drop)
    XCTAssertTrue(drop.middleware.contains(where: { $0 is AuthMiddleware<NovelCore.User> }))
  }
}
