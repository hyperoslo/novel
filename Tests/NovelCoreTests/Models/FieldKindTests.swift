import XCTest
import Fluent
@testable import NovelCore

class FieldKindTests: XCTestCase {

  typealias Key = FieldKind.Key

  static let allTests = [
    ("testAll", testAll),
  ]

  override func setUp() {
    super.setUp()
  }

  // MARK: - Tests

  func testAll() throws {
    XCTAssertEqual(FieldKind.all().count, 2)
    XCTAssertEqual(FieldKind.all(), [.plainText, .richText])
  }

  func testDescription() throws {
    XCTAssertEqual(FieldKind.plainText.description, "Plain Text")
    XCTAssertEqual(FieldKind.richText.description, "Rich Text")
    XCTAssertEqual(FieldKind.date.description, "Date")
    XCTAssertEqual(FieldKind.number.description, "Number")
    XCTAssertEqual(FieldKind.flag.description, "Flag")
    XCTAssertEqual(FieldKind.reference.description, "Reference")
  }

  func testMakeNode() throws {
    let result = try FieldKind.plainText.makeNode()

    XCTAssertEqual(result.object?.count, 2)
    XCTAssertEqual(result[Key.id.value], try FieldKind.plainText.rawValue.makeNode())
    XCTAssertEqual(result[Key.title.value], FieldKind.plainText.description.makeNode())
  }
}
