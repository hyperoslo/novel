import XCTest
import Vapor
import Fluent
@testable import NovelCore

class SessionCacheTests: XCTestCase {

  static let allTests = [
    ("testGet", testGet),
    ("testSet", testSet),
    ("testDelete", testDelete)
  ]

  var cache: SessionCache!
  let key = "token"

  override func setUp() {
    super.setUp()
    Session.database = Database(MemoryDriver())
    cache = SessionCache()
  }

  override func tearDown() {
    super.tearDown()
    Session.database = nil
  }

  // MARK: - Tests

  func testGet() throws {
    XCTAssertNil(try cache.get(key))
    try cache.set(key, 1)
    XCTAssertEqual(try cache.get(key), 1)
  }

  func testSet() throws {
    try cache.set(key, 1)
    XCTAssertEqual(try cache.get(key), 1)
  }

  func testDelete() throws {
    try cache.set(key, 1)
    XCTAssertEqual(try cache.get(key), 1)
    try cache.delete(key)
    XCTAssertNil(try cache.get(key))
  }
}
