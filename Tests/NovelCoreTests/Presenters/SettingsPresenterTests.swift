import XCTest
import Vapor
import Fluent
@testable import NovelCore

class SettingsPresenterTests: XCTestCase {

  static let allTests = [
    ("testGeneral", testGeneral),
  ]

  var presenter: SettingsPresenter!

  override func setUp() {
    super.setUp()
    Setting.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    Setting.database = nil
  }

  // MARK: - Tests

  func testGeneral() throws {
    var siteName = try createSetting(general: Setting.General.siteName)
    try siteName.save()

    var siteUrl = try createSetting(general: Setting.General.siteUrl)
    try siteUrl.save()

    presenter = SettingsPresenter()
    let node = try presenter.general()

    XCTAssertEqual(node["site_name"]?.string, siteName.value)
    XCTAssertEqual(node["site_url"]?.string, siteUrl.value)

    try siteName.delete()
    try siteUrl.delete()
  }
}
