import XCTest
@testable import NovelCore

class ApplicationTests: XCTestCase {

  static let allTests = [
    ("testCoreConfigurators", testCoreConfigurators),
  ]

  var app: Application!

  override func setUp() {
    super.setUp()
    app = Application()
  }

  func testInit() throws {
    XCTAssertEqual(app.coreConfigurators.count, 2)
    XCTAssertEqual(app.features.count, 0)
    XCTAssertEqual(app.configurators.count, 0)
  }

  func testCoreConfigurators() throws {
    let configurators = app.coreConfigurators
    XCTAssertEqual(configurators.count, 2)
    XCTAssertTrue(configurators.contains(where: { $0 is DatabaseConfigurator}))
    XCTAssertTrue(configurators.contains(where: { $0 is MiddlewareConfigurator}))
  }

  func testPrepareConfigurators() throws {
    let configurator = TestConfigurator()
    try app.prepare(configurators: [configurator])
    XCTAssertTrue(configurator.isConfigured)
  }

  func testPrepareFeatures() throws {
    let feature = TestFeature()
    try app.prepare(features: [feature])
    XCTAssertTrue((feature.configurators.first as? TestConfigurator)?.isConfigured == true)
  }
}
