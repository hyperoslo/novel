import XCTest
import Fluent
@testable import NovelCore

class SchemaTests: XCTestCase {

  static let allTests = [
    ("testTimestamp", testTimestamp),
    ("testText", testText)
  ]

  fileprivate var creator: Schema.Creator!

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testTimestamp() throws {
    creator = Schema.Creator("user")

    creator.timestamp("createdAt", optional: false, unique: false, default: "2016-12-01 23:01:00")
    XCTAssertEqual(creator.fields.count, 1)

    let field = creator.fields.first!
    XCTAssertEqual(field.name, "createdAt")

    switch field.type {
    case .custom(let string):
      XCTAssertEqual(string, "timestamp")
    default:
      XCTFail("Field type must be `timestamp`")
    }

    XCTAssertFalse(field.optional)
    XCTAssertFalse(field.unique)
    XCTAssertEqual(field.default, "2016-12-01 23:01:00")
  }

  func testText() throws {
    creator = Schema.Creator("user")

    creator.text("body", optional: false, unique: false, default: "Text")
    XCTAssertEqual(creator.fields.count, 1)

    let field = creator.fields.first!
    XCTAssertEqual(field.name, "body")

    switch field.type {
    case .custom(let string):
      XCTAssertEqual(string, "text")
    default:
      XCTFail("Field type must be `text`")
    }

    XCTAssertFalse(field.optional)
    XCTAssertFalse(field.unique)
    XCTAssertEqual(field.default, "Text")
  }
}
