import XCTest
import Vapor
import VaporPostgreSQL
@testable import NovelCore

class DatabaseConfiguratorTests: XCTestCase {

  static let allTests = [
    ("testConfigure", testConfigure),
  ]

  var configurator: DatabaseConfigurator!

  override func setUp() {
    super.setUp()
    configurator = DatabaseConfigurator()
  }

  // MARK: - Tests

  func testConfigure() throws {
    let drop = createDroplet()
    try configurator.configure(drop: drop)
    XCTAssertTrue(drop.providers.contains(where: { $0 is  VaporPostgreSQL.Provider }))
    XCTAssertEqual(drop.preparations.count, 7)
  }
}
