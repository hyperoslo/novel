import XCTest
@testable import NovelAdmin

class FeatureTests: XCTestCase {

  static let allTests = [
    ("testConfigurators", testConfigurators),
  ]

  var feature: Feature!

  override func setUp() {
    super.setUp()
    feature = Feature()
  }

  // MARK: - Tests

  func testConfigurators() {
    let configurators = feature.configurators
    XCTAssertEqual(configurators.count, 3)
    XCTAssertTrue(configurators.contains(where: { $0 is RouteConfigurator}))
    XCTAssertTrue(configurators.contains(where: { $0 is LeafConfigurator}))
    XCTAssertTrue(configurators.contains(where: { $0 is SettingsConfigurator}))
  }
}
