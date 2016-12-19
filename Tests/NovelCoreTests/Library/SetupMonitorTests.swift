import XCTest
import Vapor
import Fluent
@testable import NovelCore

class SetupMonitorTests: XCTestCase {

  static let allTests = [
    ("testIsCompletedWithNoUser", testIsCompletedWithNoUser),
    ("testIsCompletedWithUser", testIsCompletedWithUser)
  ]

  override func setUp() {
    super.setUp()
    User.database = Database(MemoryDriver())
  }

  override func tearDown() {
    super.tearDown()
    User.database = nil
  }

  // MARK: - Tests

  func testIsCompletedWithNoUser() throws {
    XCTAssertFalse(SetupMonitor.isCompleted)
  }

  func testIsCompletedWithUser() throws {
    var user = try createUser()
    try user.save()
    XCTAssertTrue(SetupMonitor.isCompleted)
  }
}
